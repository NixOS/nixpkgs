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
  kdePackages,
  # leapsdk
  # leapv2
  libGL,
  libX11,
  libXrandr,
  libbsd,
  libdrm,
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
  opencomposite,
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
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "wivrn";
    repo = "wivrn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KpsS0XssSnE2Fj5rrXq1h+yNHhF7BzfPxwRUhZUZEaw=";
  };

  monado = applyPatches {
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = "848a24aa106758fd6c7afcab6d95880c57dbe450";
      hash = "sha256-+rax9/CG/3y8rLYwGqoWJa4FxH+Z3eREiwhuxDOUzLs=";
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
    theirMonadoRev=$(sed -n '/FetchContent_Declare(monado/,/)/p' ${finalAttrs.src.name}/CMakeLists.txt | grep "GIT_TAG" | awk '{print $2}')
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
      kdePackages.kcoreaddons
      kdePackages.ki18n
      kdePackages.kiconthemes
      kdePackages.kirigami
      kdePackages.qcoro
      kdePackages.qqc2-desktop-style
      libbsd
      libdrm
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
      qt6.qtsvg
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

  cmakeFlags =
    [
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
      (lib.cmakeFeature "OPENCOMPOSITE_SEARCH_PATH" "${opencomposite}")
      (lib.cmakeFeature "GIT_DESC" "v${finalAttrs.version}")
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONADO" "${finalAttrs.monado}")
    ]
    ++ lib.optionals cudaSupport [
      (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${cudaPackages.cudatoolkit}")
    ];

  postFixup = ''
    wrapProgram $out/bin/wivrn-dashboard \
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
