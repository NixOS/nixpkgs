{
  # Commented packages are not currently in nixpkgs. They don't appear to cause a problem when not present.
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  applyPatches,
  autoAddDriverRunpath,
  avahi,
  bluez,
  boost,
  cjson,
  cli11,
  cmake,
  cudaPackages ? { },
  cudaSupport ? config.cudaSupport,
  dbus,
  # depthai
  doxygen,
  eigen,
  elfutils,
  ffmpeg,
  freetype,
  git,
  glib,
  glm,
  glslang,
  gst_all_1,
  harfbuzz,
  hidapi,
  # leapsdk
  # leapv2
  libGL,
  libX11,
  libXrandr,
  libbsd,
  libdrm,
  libdwg,
  libjpeg,
  libmd,
  libnotify,
  libpulseaudio,
  librealsense,
  librsvg,
  libsurvive,
  libunwind,
  libusb1,
  libuvc,
  libva,
  makeDesktopItem,
  nix-update-script,
  nlohmann_json,
  onnxruntime,
  opencv4,
  openhmd,
  openvr,
  openxr-loader,
  orc,
  # percetto
  pipewire,
  pkg-config,
  python3,
  qt6,
  SDL2,
  shaderc,
  spdlog,
  systemd,
  udev,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-protocols,
  wayland-scanner,
  x264,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wivrn";
  version = "0.22";

  src = fetchFromGitHub {
    owner = "wivrn";
    repo = "wivrn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-i/CG+zD64cwnu0z1BRkRn7Wm67KszE+wZ5geeAvrvMY=";
  };

  monado = applyPatches {
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = "aa2b0f9f1d638becd6bb9ca3c357ac2561a36b07";
      hash = "sha256-yfHtkMvX/gyVG0UgpSB6KjSDdCym6Reb9LRb3OortaI=";
    };

    patches = [
      ./force-enable-steamvr_lh.patch
    ];

    postPatch = ''
      ${finalAttrs.src}/patches/apply.sh ${finalAttrs.src}/patches/monado/*
    '';
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

  nativeBuildInputs =
    [
      cmake
      doxygen
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

  buildInputs =
    [
      avahi
      boost
      bluez
      cjson
      cli11
      dbus
      eigen
      elfutils
      ffmpeg
      freetype
      glib
      glm
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
      harfbuzz
      hidapi
      libbsd
      libdrm
      libdwg
      libGL
      libjpeg
      libmd
      libnotify
      librealsense
      libsurvive
      libunwind
      libusb1
      libuvc
      libva
      libX11
      libXrandr
      libpulseaudio
      nlohmann_json
      opencv4
      openhmd
      openvr
      openxr-loader
      onnxruntime
      orc
      pipewire
      qt6.qtbase
      qt6.qttools
      SDL2
      shaderc
      spdlog
      systemd
      udev
      vulkan-headers
      vulkan-loader
      wayland
      wayland-protocols
      wayland-scanner
      x264
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cudatoolkit
    ];

  cmakeFlags = [
    (lib.cmakeBool "WIVRN_USE_NVENC" cudaSupport)
    (lib.cmakeBool "WIVRN_USE_VAAPI" true)
    (lib.cmakeBool "WIVRN_USE_VULKAN" true)
    (lib.cmakeBool "WIVRN_USE_X264" true)
    (lib.cmakeBool "WIVRN_USE_PIPEWIRE" true)
    (lib.cmakeBool "WIVRN_USE_PULSEAUDIO" true)
    (lib.cmakeBool "WIVRN_FEATURE_STEAMVR_LIGHTHOUSE" true)
    (lib.cmakeBool "WIVRN_BUILD_CLIENT" false)
    (lib.cmakeBool "WIVRN_BUILD_DASHBOARD" true)
    (lib.cmakeBool "WIVRN_CHECK_CAPSYSNICE" false)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "WIVRN_OPENXR_MANIFEST_TYPE" "absolute")
    (lib.cmakeFeature "GIT_DESC" "${finalAttrs.version}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONADO" "${finalAttrs.monado}")
    (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${cudaPackages.cudatoolkit}")
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "WiVRn Server";
      desktopName = "WiVRn Server";
      genericName = "WiVRn Server";
      comment = "Play your PC VR games on a standalone headset";
      icon = "io.github.wivrn.wivrn";
      exec = "wivrn-dashboard";
      type = "Application";
      categories = [
        "Network"
        "Game"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "An OpenXR streaming application to a standalone headset";
    homepage = "https://github.com/WiVRn/WiVRn/";
    changelog = "https://github.com/WiVRn/WiVRn/releases/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ passivelemon ];
    platforms = platforms.linux;
    mainProgram = "wivrn-server";
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
})
