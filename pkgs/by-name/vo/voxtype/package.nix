{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  clang,
  libclang,
  git,
  alsa-lib,
  openssl,
  wtype,
  wl-clipboard,
  dotool,
  xdotool,
  xclip,
  libnotify,
  pciutils,
  apple-sdk,
  makeBinaryWrapper,
  installShellFiles,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,

  vulkanSupport ? false,
  shaderc,
  vulkan-headers,
  vulkan-loader,

  rocmSupport ? config.rocmSupport,
  rocmPackages,

  cudaSupport ? config.cudaSupport,
  cudaPackages,

  metalSupport ? (stdenv.hostPlatform == "aarch64-darwin"),

  onnxSupport ? false,
  onnxruntime,

  waylandSupport ? stdenv.hostPlatform.isLinux,
  waylandRuntimePackages ? [
    wtype
    dotool
    wl-clipboard
  ],

  x11Support ? stdenv.hostPlatform.isLinux,
  x11RuntimePackages ? [
    xdotool
    xclip
  ],
}:
let
  onnxruntime' = onnxruntime.override { inherit rocmSupport cudaSupport; };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "voxtype";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "peteonrails";
    repo = "voxtype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B9/Aiffb0ukt4I1y2qlkrulukfMiao4JwkQF63l7ouU=";
  };
  cargoHash = "sha256-yT3xqcIPtIgKBBeu56t4fWBMHaUfM9ROuL9IVCi0EhA=";

  nativeBuildInputs = [
    cmake
    pkg-config
    clang
    git # Required by whisper.cpp cmake
    installShellFiles
    makeBinaryWrapper
  ]
  ++ lib.optionals vulkanSupport [
    shaderc
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals rocmSupport (
    with rocmPackages;
    [
      clr
      hipblas
      rocblas
    ]
  )
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_nvcc
    ]
  );
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk ]
  ++ lib.optionals vulkanSupport [
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals rocmSupport (
    with rocmPackages;
    [
      clr
      hipblas
      rocblas
    ]
  )
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_nvcc
    ]
  )
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cudatoolkit
      cudnn
    ]
  )
  ++ lib.optionals onnxSupport [
    onnxruntime'
  ];

  env = {
    # NOTE: set LIBCLANG_PATH so bindgen can locate libclang
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";

    # NOTE: Ensure reproducible builds targeting AVX2-capable CPUs (x86-64-v3)
    # This matches the portable AVX2 binaries we ship for other distros
    RUSTFLAGS = lib.optionalString (stdenv.hostPlatform == "x86_64-linux") "-C target-cpu=x86-64-v3";
  };
  # Build with specified features
  buildFeatures =
    [ ]
    ++ lib.optionals vulkanSupport [ "gpu-vulkan" ]
    ++ lib.optionals rocmSupport [ "gpu-hipblas" ]
    ++ lib.optionals cudaSupport [ "gpu-cuda" ]
    ++ lib.optionals metalSupport [ "gpu-metal" ]
    ++ lib.optionals onnxSupport [
      "parakeet-load-dynamic"
      "moonshine"
      "sensevoice"
      "paraformer"
      "dolphin"
      "omnilingual"
    ]
    ++ lib.optionals (onnxSupport && rocmSupport) [
      "parakeet-load-dynamic"
      "parakeet-rocm"
      "moonshine"
      "sensevoice"
      "paraformer"
      "dolphin"
      "omnilingual"
    ]
    ++ lib.optionals (onnxSupport && cudaSupport) [
      "parakeet-load-dynamic"
      "parakeet-cuda"
      "moonshine-cuda"
      "sensevoice-cuda"
      "paraformer-cuda"
      "dolphin-cuda"
      "omnilingual-cuda"
    ];

  preBuild = ''
    # NOTE: whisper.cpp cmake needs some help in sandbox
    export CMAKE_BUILD_PARALLEL_LEVEL=$NIX_BUILD_CORES
  ''
  + lib.optionalString vulkanSupport ''
    export CMAKE_BUILD_PARALLEL_LEVEL=$NIX_BUILD_CORES
    export VULKAN_SDK="${vulkan-loader}"
    export Vulkan_INCLUDE_DIR="${vulkan-headers}/include"
    export Vulkan_LIBRARY="${lib.getLib vulkan-loader}/lib/libvulkan.so"
  ''
  + lib.optionalString rocmSupport ''
    export CMAKE_BUILD_PARALLEL_LEVEL=$NIX_BUILD_CORES
    export HIP_PATH="${rocmPackages.clr}"
    export ROCM_PATH="${rocmPackages.clr}"
  ''
  + lib.optionalString onnxSupport ''
    export ORT_LIB_LOCATION="${lib.getLib onnxruntime'}/lib"
  '';

  postInstall = ''
    install -Dm644 config/default.toml \
      $out/share/voxtype/default-config.toml

    wrapProgram $out/bin/voxtype \
      --prefix PATH : ${
        (lib.makeBinPath (
          [
            libnotify
          ]
          ++ lib.optionals (vulkanSupport || rocmSupport || cudaSupport) [
            pciutils
          ]
          ++ lib.optionals waylandSupport waylandRuntimePackages
          ++ lib.optionals x11Support x11RuntimePackages
        ))
        + lib.optionalString onnxSupport " \\"
      }
      ${lib.optionalString onnxSupport ''
         --set ORT_DYLIB_PATH "${lib.getLib onnxruntime'}/lib/libonnxruntime.${
           if stdenv.hostPlatform.isDarwin then "dylib" else "so"
         }" \
        --prefix LD_LIBRARY_PATH : "${lib.getLib onnxruntime'}/lib"
      ''}
  ''
  + lib.optionalString installManPages ''
    # TODO: where are the man pages?
    # installManPage target/man/*
  ''
  + lib.optionalString installShellCompletions ''
    installShellCompletion packaging/completions/voxtype.{bash,zsh,fish}

  '';

  doCheck = false;

  meta = with lib; {
    description = "Push-to-talk voice-to-text for Linux";
    longDescription = ''
      Voxtype is a push-to-talk voice-to-text daemon for Linux.
      Hold a hotkey while speaking, release to transcribe and output
      text at your cursor position. Supports Whisper, Parakeet,
      SenseVoice, Moonshine, Paraformer, Dolphin, and Omnilingual engines.
    '';
    homepage = "https://voxtype.io";
    license = licenses.mit;
    maintainers = [ ]; # Add NixOS maintainers when upstreaming
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    mainProgram = "voxtype";
  };
})
