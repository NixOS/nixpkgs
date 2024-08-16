{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, dtkwidget
, wayland
, dwayland
, qt5integration
, qt5platform-plugins
, image-editor
, qtbase
, qtmultimedia
, ffmpeg
, ffmpegthumbnailer
, libusb1
, libpciaccess
, portaudio
, libv4l
, gst_all_1
, systemd
}:

stdenv.mkDerivation rec {
  pname = "deepin-camera";
  version = "unstable-2023-09-26";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = "8ad3b6ad2a4f5f0b22a216496a0187a69a1e1bcc";
    hash = "sha256-/8ddplHJzeu7lrRzN66KhJGkFou4FcXc+BzYFK5YVeE=";
  };

  # QLibrary and dlopen work with LD_LIBRARY_PATH
  patches = [ ./dont_use_libPath.diff ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace "/usr/share/libimagevisualresult" "${image-editor}/share/libimagevisualresult" \
      --replace "/usr/include/libusb-1.0" "${lib.getDev libusb1}/include/libusb-1.0"
    substituteInPlace src/com.deepin.Camera.service \
      --replace "/usr/bin/qdbus" "${lib.getBin qttools}/bin/qdbus" \
      --replace "/usr/share" "$out/share"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    wayland
    dwayland
    qt5integration
    qt5platform-plugins
    image-editor
    qtbase
    qtmultimedia
    ffmpeg
    ffmpegthumbnailer
    libusb1
    libpciaccess
    portaudio
    libv4l
  ] ++ (with gst_all_1 ; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ]);

  cmakeFlags = [ "-DVERSION=${version}" ];

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${gst_all_1.gstreamer.dev}/include/gstreamer-1.0"
    "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0"
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ ffmpeg ffmpegthumbnailer gst_all_1.gstreamer gst_all_1.gst-plugins-base libusb1 libv4l portaudio systemd ]}"
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Tool to view camera, take photo and video";
    homepage = "https://github.com/linuxdeepin/deepin-camera";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
