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
  glib,
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
  version = "0.20";

  src = fetchFromGitHub {
    owner = "wivrn";
    repo = "wivrn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mxvfwp/9CUoc6tU3KW257qlpXEZu7tK33jxn1TjAZYc=";
  };

  monado = applyPatches {
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = "d7089f182b0514e13554e99512d63e69c30523c5";
      hash = "sha256-5+8cFDQ2ptaBIJMdZ6gyb0GSL8vBaZktbuBnRlTWOmg=";
    };

    patches = (
      map (f: "${finalAttrs.src}/patches/monado/${f}") [
        "0002-ipc-server-Always-listen-to-stdin.patch"
        "0003-Use-extern-socket-fd.patch"
        "0005-distortion-images.patch"
        "0008-Use-mipmaps-for-distortion-shader.patch"
        "0009-convert-to-YCbCr-in-monado.patch"
        "0010-d-solarxr-Add-SolarXR-WebSockets-driver.patch"
      ]
    );
  };

  strictDeps = true;

  postUnpack = ''
    # Let's make sure our monado source revision matches what is used by WiVRn upstream
    ourMonadoRev="${finalAttrs.monado.src.rev}"
    theirMonadoRev=$(grep "GIT_TAG" ${finalAttrs.src.name}/CMakeLists.txt | awk '{print $2}')
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
    glslang
    pkg-config
    python3
    glib # provide gdbus-codegen
  ] ++ lib.optionals cudaSupport [ autoAddDriverRunpath ];

  buildInputs = [
    avahi
    boost
    cli11
    eigen
    ffmpeg
    freetype
    glm
    glib
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
