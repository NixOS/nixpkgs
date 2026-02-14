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
  glib,
  glm,
  glslang,
  harfbuzz,
  kdePackages,
  libarchive,
  libdrm,
  libGL,
  libnotify,
  libpulseaudio,
  librsvg,
  libva,
  libx11,
  libxrandr,
  makeDesktopItem,
  nix-update-script,
  nlohmann_json,
  opencomposite,
  openxr-loader,
  ovrCompatSearchPaths ? "${xrizer}/lib/xrizer:${opencomposite}/lib/opencomposite",
  pipewire,
  pkg-config,
  python3,
  qt6,
  shaderc,
  systemd,
  udev,
  vulkan-headers,
  vulkan-loader,
  x264,
  xrizer,
  # Only build the OpenXR client library. Useful for building the client library for a different architecture,
  # e.g. 32-bit library while running 64-bit service on host, so 32-bit apps can connect to the runtime
  clientLibOnly ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wivrn";
  version = "26.2.1";

  src = fetchFromGitHub {
    owner = "wivrn";
    repo = "wivrn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-s5SQcQ1giU1boO2W6GdzInmTD669oApLthBc3lwnHbY=";
  };

  monado = applyPatches {
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = "723652b545a79609f9f04cb89fcbf807d9d6451a";
      hash = "sha256-wGqvTI/X22apc8XCN3GCGQClHfBW5xk73mZnwWvHtyI=";
    };

    postPatch = ''
      ${finalAttrs.src}/patches/apply.sh ${finalAttrs.src}/patches/monado/*
    '';
  };

  strictDeps = true;

  # Let's make sure our monado source revision matches what is used by WiVRn upstream
  postUnpack = ''
    ourMonadoRev="${finalAttrs.monado.src.rev}"
    theirMonadoRev=$(cat ${finalAttrs.src.name}/monado-rev)
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
    glib
    glslang
    librsvg
    pkg-config
    python3
  ]
  ++ lib.optionals (!clientLibOnly) [
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
  ];

  buildInputs = [
    eigen
    freetype
    glm
    harfbuzz
    libGL
    libx11
    libxrandr
    openxr-loader
    shaderc
    systemd
    udev
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals (!clientLibOnly) [
    avahi
    boost
    cli11
    ffmpeg
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kirigami
    kdePackages.qcoro
    kdePackages.qqc2-desktop-style
    libarchive
    libdrm
    libnotify
    libpulseaudio
    librsvg
    libva
    nlohmann_json
    pipewire
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    x264
  ]
  ++ lib.optionals (cudaSupport && !clientLibOnly) [
    cudaPackages.cudatoolkit
  ];

  cmakeFlags = [
    (lib.cmakeBool "WIVRN_BUILD_CLIENT" false)
    (lib.cmakeBool "WIVRN_BUILD_DASHBOARD" (!clientLibOnly))
    (lib.cmakeBool "WIVRN_BUILD_SERVER" (!clientLibOnly))
    (lib.cmakeBool "WIVRN_BUILD_SERVER_LIBRARY" true)
    (lib.cmakeBool "WIVRN_BUILD_WIVRNCTL" (!clientLibOnly))
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "WIVRN_OPENXR_MANIFEST_TYPE" "absolute")
    (lib.cmakeBool "WIVRN_OPENXR_MANIFEST_ABI" clientLibOnly)
    (lib.cmakeFeature "GIT_DESC" "v${finalAttrs.version}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONADO" "${finalAttrs.monado}")
  ]
  ++ lib.optionals (!clientLibOnly) [
    (lib.cmakeBool "WIVRN_USE_NVENC" cudaSupport)
    (lib.cmakeBool "WIVRN_USE_VAAPI" true)
    (lib.cmakeBool "WIVRN_USE_VULKAN_ENCODE" true)
    (lib.cmakeBool "WIVRN_USE_X264" true)
    (lib.cmakeBool "WIVRN_USE_PIPEWIRE" true)
    (lib.cmakeBool "WIVRN_USE_PULSEAUDIO" true)
    (lib.cmakeBool "WIVRN_FEATURE_STEAMVR_LIGHTHOUSE" true)
    (lib.cmakeFeature "OVR_COMPAT_SEARCH_PATH" ovrCompatSearchPaths)
  ]
  ++ lib.optionals (cudaSupport && !clientLibOnly) [
    (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${cudaPackages.cudatoolkit}")
  ];

  dontWrapQtApps = true;

  preFixup = lib.optional (!clientLibOnly) ''
    wrapQtApp "$out/bin/wivrn-dashboard" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  desktopItems = lib.optionals (!clientLibOnly) [
    (makeDesktopItem {
      name = "WiVRn Server";
      desktopName = "WiVRn Server";
      genericName = "WiVRn Server";
      comment = "Play your PC VR games on a standalone headset";
      icon = "io.github.wivrn.wivrn";
      exec = "wivrn-dashboard";
      type = "Application";
      categories = [ "Network" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenXR streaming application to a standalone headset";
    homepage = "https://github.com/WiVRn/WiVRn/";
    changelog = "https://github.com/WiVRn/WiVRn/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      ImSapphire
      passivelemon
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wivrn-server";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
