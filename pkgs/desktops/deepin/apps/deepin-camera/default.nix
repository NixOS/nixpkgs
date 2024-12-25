{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  dtkwidget,
  wayland,
  dwayland,
  qt5integration,
  qt5platform-plugins,
  image-editor,
  ffmpeg_6,
  ffmpegthumbnailer,
  libusb1,
  libpciaccess,
  portaudio,
  libv4l,
  gst_all_1,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "deepin-camera";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-3q8yV8GpCPKW780YpCn+xLeFBGJFoAMmKSFCAH9OXoE=";
  };

  # QLibrary and dlopen work with LD_LIBRARY_PATH
  patches = [ ./dont_use_libPath.diff ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace "/usr/share/libimagevisualresult" "${image-editor}/share/libimagevisualresult" \
      --replace "/usr/include/libusb-1.0" "${lib.getDev libusb1}/include/libusb-1.0"
    substituteInPlace src/com.deepin.Camera.service \
      --replace "/usr/bin/qdbus" "${lib.getBin libsForQt5.qttools}/bin/qdbus" \
      --replace "/usr/share" "$out/share"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs =
    [
      dtkwidget
      wayland
      dwayland
      qt5integration
      qt5platform-plugins
      image-editor
      libsForQt5.qtbase
      libsForQt5.qtmultimedia
      ffmpeg_6
      ffmpegthumbnailer
      libusb1
      libpciaccess
      portaudio
      libv4l
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
    ]);

  cmakeFlags = [ "-DVERSION=${version}" ];

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${gst_all_1.gstreamer.dev}/include/gstreamer-1.0"
    "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0"
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        ffmpeg_6
        ffmpegthumbnailer
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        libusb1
        libv4l
        portaudio
        systemd
      ]
    }"
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    description = "Tool to view camera, take photo and video";
    homepage = "https://github.com/linuxdeepin/deepin-camera";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
