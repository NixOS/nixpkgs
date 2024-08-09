{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  applyPatches,
  autoAddDriverRunpath,
  avahi,
  boost,
  cli11,
  cmake,
  cudaPackages ? { },
  cudaSupport ? config.cudaSupport,
  eigen,
  ffmpeg,
  freetype,
  git,
  glm,
  glslang,
  harfbuzz,
  libdrm,
  libGL,
  libva,
  libpulseaudio,
  libX11,
  libXrandr,
  nix-update-script,
  nlohmann_json,
  onnxruntime,
  openxr-loader,
  pipewire,
  pkg-config,
  python3,
  shaderc,
  spdlog,
  systemd,
  udev,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
  x264,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wivrn";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "meumeu";
    repo = "wivrn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wG758cLhUUjiA3iVV4xal3CXVMoE/SNOEtzUWphNYuk=";
  };

  monado = applyPatches {
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = "28cb225be12a8a55c221f22103c235aff6de3883";
      hash = "sha256-lFy0VvaLD4Oyu2TZJnaIWjuaJUZjGGDJS0VsRfIUpcc=";
    };

    patches = [
      "${finalAttrs.src}/patches/monado/0001-c-multi-disable-dropping-of-old-frames.patch"
      "${finalAttrs.src}/patches/monado/0002-ipc-server-Always-listen-to-stdin.patch"
      "${finalAttrs.src}/patches/monado/0003-c-multi-Don-t-log-frame-time-diff.patch"
    ];
  };

  strictDeps = true;

  postUnpack = ''
    # Let's make sure our monado source revision matches what is used by WiVRn upstream
    ourMonadoRev="${finalAttrs.monado.src.rev}"
    theirMonadoRev=$(grep -A1 "https://gitlab.freedesktop.org/monado/monado" ${finalAttrs.src.name}/CMakeLists.txt | tail -n1 | sed 's/.*GIT_TAG\s*//')
    if [ ! "$theirMonadoRev" == "$ourMonadoRev" ]; then
      echo "Our Monado source revision doesn't match CMakeLists.txt." >&2
      echo "  theirs: $theirMonadoRev" >&2
      echo "    ours: $ourMonadoRev" >&2
      return 1
    fi
  '';

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    python3
  ] ++ lib.optionals cudaSupport [ autoAddDriverRunpath ];

  buildInputs = [
    avahi
    boost
    cli11
    eigen
    ffmpeg
    freetype
    glm
    glslang
    harfbuzz
    libdrm
    libGL
    libva
    libX11
    libXrandr
    libpulseaudio
    nlohmann_json
    onnxruntime
    openxr-loader
    pipewire
    shaderc
    spdlog
    systemd
    udev
    vulkan-headers
    vulkan-loader
    vulkan-tools
    x264
  ] ++ lib.optionals cudaSupport [ cudaPackages.cudatoolkit ];

  cmakeFlags = [
    (lib.cmakeBool "WIVRN_USE_VAAPI" true)
    (lib.cmakeBool "WIVRN_USE_X264" true)
    (lib.cmakeBool "WIVRN_USE_NVENC" cudaSupport)
    (lib.cmakeBool "WIVRN_USE_SYSTEMD" true)
    (lib.cmakeBool "WIVRN_USE_PIPEWIRE" true)
    (lib.cmakeBool "WIVRN_USE_PULSEAUDIO" true)
    (lib.cmakeBool "WIVRN_BUILD_CLIENT" false)
    (lib.cmakeBool "WIVRN_OPENXR_INSTALL_ABSOLUTE_RUNTIME_PATH" true)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONADO" "${finalAttrs.monado}")
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "An OpenXR streaming application to a standalone headset";
    homepage = "https://github.com/Meumeu/WiVRn/";
    changelog = "https://github.com/Meumeu/WiVRn/releases/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ passivelemon ];
    platforms = platforms.linux;
    mainProgram = "wivrn-server";
  };
})
