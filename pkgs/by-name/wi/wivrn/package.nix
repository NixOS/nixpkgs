{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
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
  libX11,
  libXrandr,
  makeDesktopItem,
  nix-update-script,
  nlohmann_json,
  onnxruntime,
  opencomposite,
  openxr-loader,
  ovrCompatSearchPaths ? "${xrizer}/lib/xrizer:${opencomposite}/lib/opencomposite",
  pipewire,
  pkg-config,
  python3,
  qt6,
  shaderc,
  spdlog,
  systemd,
  udev,
  vulkan-headers,
  vulkan-loader,
  x264,
  xrizer,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wivrn";
  version = "25.9";

  src = fetchFromGitHub {
    owner = "wivrn";
    repo = "wivrn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XP0bpXgtira2QIlS0fNEteNP48WnEjBYFM1Xmt2sm5I=";
  };

  monado = applyPatches {
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = "7a4018e2d89151e60e562fac79eba90ca7a328d8";
      hash = "sha256-DPIvJb23bK7SDjZr9mK0Wt6Zbo3Ari3Ar8TtPe5QgKY=";
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
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
  ];

  buildInputs = [
    avahi
    boost
    cli11
    eigen
    ffmpeg
    freetype
    glm
    harfbuzz
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kirigami
    kdePackages.qcoro
    kdePackages.qqc2-desktop-style
    libarchive
    libdrm
    libGL
    libnotify
    libpulseaudio
    librsvg
    libva
    libX11
    libXrandr
    nlohmann_json
    openxr-loader
    onnxruntime
    pipewire
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    shaderc
    spdlog
    systemd
    udev
    vulkan-headers
    vulkan-loader
    x264
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
  ];

  cmakeFlags = [
    (lib.cmakeBool "WIVRN_USE_NVENC" cudaSupport)
    (lib.cmakeBool "WIVRN_USE_VAAPI" true)
    (lib.cmakeBool "WIVRN_USE_VULKAN_ENCODE" true)
    (lib.cmakeBool "WIVRN_USE_X264" true)
    (lib.cmakeBool "WIVRN_USE_PIPEWIRE" true)
    (lib.cmakeBool "WIVRN_USE_PULSEAUDIO" true)
    (lib.cmakeBool "WIVRN_FEATURE_STEAMVR_LIGHTHOUSE" true)
    (lib.cmakeBool "WIVRN_BUILD_CLIENT" false)
    (lib.cmakeBool "WIVRN_BUILD_DASHBOARD" true)
    (lib.cmakeBool "WIVRN_CHECK_CAPSYSNICE" false)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "WIVRN_OPENXR_MANIFEST_TYPE" "absolute")
    (lib.cmakeFeature "OVR_COMPAT_SEARCH_PATH" ovrCompatSearchPaths)
    (lib.cmakeFeature "GIT_DESC" "v${finalAttrs.version}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONADO" "${finalAttrs.monado}")
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${cudaPackages.cudatoolkit}")
  ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/wivrn-dashboard" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  desktopItems = [
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
