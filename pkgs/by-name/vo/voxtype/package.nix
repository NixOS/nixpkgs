{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,

  clang,
  cmake,
  gitMinimal,
  installShellFiles,
  libclang,
  makeBinaryWrapper,
  pkg-config,

  alsa-lib,
  dotool,
  libnotify,
  libxkbcommon,
  openssl,
  pciutils,
  pulseaudio,
  wl-clipboard,
  wtype,
  ydotool,
  which,
  xclip,
  xdotool,

  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,

  vulkanSupport ? false,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  wayland,

  onnxSupport ? false,
  onnxruntime,

  osdGtk4Support ? false,
  osdNativeSupport ? false,

  wrapGAppsHook4,
  gtk4-layer-shell,

  hipSupport ? false,
  rocmPackages,
  rocmGpuTargets ? builtins.concatStringsSep ";" rocmPackages.clr.gpuTargets,

  waylandSupport ? stdenv.hostPlatform.isLinux,
  waylandRuntimePackages ? [
    dotool
    wl-clipboard
    wtype
    ydotool
  ],

  x11Support ? stdenv.hostPlatform.isLinux,
  x11RuntimePackages ? [
    xclip
    xdotool
  ],
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "voxtype";
  version = "1.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "peteonrails";
    repo = "voxtype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Djbq7nUIqL3afCEYKnPWtRnx4jXBvhY4iA1m/4w8Ak=";
  };

  # The lock file pins openvino-genai to a git fork whose openvino-sys crate
  # carries a submodule with a symlink loop, which fetchCargoVendor cannot
  # copy. The fork only matters for the openvino-whisper feature, which is not
  # built here, so resolve it from crates.io instead.
  cargoPatches = [ ./openvino-genai-from-crates-io.patch ];

  cargoHash = "sha256-/3EINM6XjftYdi8B2/WQ+62vhOC/wX4x156IjXLmNv8=";

  buildFeatures =
    [ ]
    ++ lib.optionals vulkanSupport [ "gpu-vulkan" ]
    ++ lib.optionals hipSupport [ "gpu-hipblas" ]
    ++ lib.optionals onnxSupport [
      "parakeet-load-dynamic"
      "moonshine"
      "sensevoice"
      "paraformer"
      "dolphin"
      "omnilingual"
      "cohere"
      "onnx-load-dynamic"
    ]
    ++ lib.optionals osdGtk4Support [
      "osd-gtk4"
    ]
    ++ lib.optionals osdNativeSupport [
      "osd-native"
    ];

  nativeBuildInputs = [
    cmake
    clang
    gitMinimal # Required by whisper.cpp cmake
    installShellFiles
    makeBinaryWrapper
    pkg-config
  ]
  ++ lib.optionals hipSupport [
    rocmPackages.clr
  ]
  ++ lib.optionals vulkanSupport [
    shaderc
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals osdGtk4Support [
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
    openssl
  ]
  ++ lib.optionals hipSupport (
    with rocmPackages;
    [
      clr
      hipblas
      rocblas
    ]
  )
  ++ lib.optionals vulkanSupport [
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals onnxSupport [
    onnxruntime
  ]
  ++ lib.optionals osdGtk4Support [
    gtk4-layer-shell
  ]
  ++ lib.optionals osdNativeSupport [
    libxkbcommon
  ];

  env = {
    # NOTE: set LIBCLANG_PATH so bindgen can locate libclang
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";

    # NOTE: Ensure reproducible builds targeting AVX2-capable CPUs (x86-64-v3)
    # This matches the portable AVX2 binaries we ship for other distros
    RUSTFLAGS = lib.optionalString (
      stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64
    ) "-C target-cpu=x86-64-v3";
  }
  // lib.optionalAttrs hipSupport {
    HIP_PATH = "${rocmPackages.clr}";
    AMDGPU_TARGETS = rocmGpuTargets;
  };

  preBuild = ''
    # NOTE: whisper.cpp cmake needs some help in sandbox
    export CMAKE_BUILD_PARALLEL_LEVEL=$NIX_BUILD_CORES
  ''
  + lib.optionalString vulkanSupport ''
    export VULKAN_SDK="${shaderc.bin}"
  ''
  + lib.optionalString onnxSupport ''
    export ORT_LIB_LOCATION="${lib.getLib onnxruntime}/lib"
  '';

  postInstall = ''
    install -Dm644 config/default.toml \
      $out/share/voxtype/default-config.toml

    # NOTE: include $out/bin so the daemon finds the on-screen display (OSD) frontends it spawns.
    wrapProgram $out/bin/voxtype \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${
        (lib.makeBinPath (
          [
            libnotify
            pulseaudio # pactl for media ducking
            which
          ]
          ++ lib.optionals vulkanSupport [
            pciutils
          ]
          ++ lib.optionals waylandSupport waylandRuntimePackages
          ++ lib.optionals x11Support x11RuntimePackages
        ))
        + lib.optionalString onnxSupport " \\"
      }
      ${lib.optionalString onnxSupport ''
        --set ORT_DYLIB_PATH "${lib.getLib onnxruntime}/lib/libonnxruntime.so" \
        --prefix LD_LIBRARY_PATH : "${lib.getLib onnxruntime}/lib"
      ''}
  ''
  # Wrap the native on-screen display binary so it finds Wayland and xkb at runtime,
  # plus Vulkan when transcription GPU support is enabled.
  # osdNativeSupport stays opt-in via dedicated wrappers; enable via override when needed.
  + lib.optionalString osdNativeSupport ''
    wrapProgram $out/bin/voxtype-osd-native \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath (
          [
            libxkbcommon
            wayland
          ]
          ++ lib.optional vulkanSupport vulkan-loader
        )
      }"
  ''
  + lib.optionalString installManPages ''
    installManPage target/${stdenv.hostPlatform.rust.cargoShortTarget}/$cargoBuildType/build/voxtype-*/out/man/*
  ''
  + lib.optionalString installShellCompletions ''
    installShellCompletion packaging/completions/voxtype.{bash,zsh,fish}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.update-script = nix-update-script { };

  meta = {
    description = "Voice-to-text with push-to-talk for Wayland compositors";
    longDescription = ''
      Voxtype is a push-to-talk voice-to-text daemon for Linux.
      Hold a hotkey while speaking, release to transcribe and output
      text at your cursor position. Supports Whisper, Parakeet,
      SenseVoice, Moonshine, Paraformer, Dolphin, and Omnilingual engines.
    '';
    homepage = "https://voxtype.io";
    downloadPage = "https://voxtype.io/download/";
    changelog = "https://github.com/peteonrails/voxtype/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      DuskyElf
      pbek
    ];
    platforms = lib.platforms.linux;
    mainProgram = "voxtype";
  };
})
