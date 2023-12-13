{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, wrapQtAppsHook
, qtbase
, qttools
, qtx11extras
, qtmultimedia
, dtkwidget
, qt5integration
, qt5platform-plugins
, qtmpris
, qtdbusextended
, gsettings-qt
, elfutils
, ffmpeg
, ffmpegthumbnailer
, mpv
, xorg
, pcre
, libdvdread
, libdvdnav
, libunwind
, libva
, zstd
, glib
, gst_all_1
, gtest
, libpulseaudio
, runtimeShell
}:

stdenv.mkDerivation rec {
  pname = "deepin-movie-reborn";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-dWN2IVVpwYwzEuLtT3JvhzKiBwaBq4lzmaEhA9S1hjE=";
  };

  patches = [
    ./dont_use_libPath.diff
  ];

  postPatch = ''
    # https://github.com/linuxdeepin/deepin-movie-reborn/pull/198
    substituteInPlace src/common/diskcheckthread.cpp \
      --replace "/usr/include/linux/cdrom.h" "linux/cdrom.h"
    # https://github.com/linuxdeepin/deepin-movie-reborn/pull/337
    substituteInPlace src/libdmr/playlist_model.cpp \
      --replace "DGuiApplicationHelper" "Dtk::Gui::DGuiApplicationHelper"
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    qtx11extras
    qtmultimedia
    qtdbusextended
    qtmpris
    gsettings-qt
    elfutils
    ffmpeg
    ffmpegthumbnailer
    xorg.libXtst
    xorg.libXdmcp
    xorg.xcbproto
    pcre.dev
    libdvdread
    libdvdnav
    libunwind
    libva
    zstd
    mpv
    gtest
    libpulseaudio
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
  ]);

  propagatedBuildInputs = [
    qtmultimedia
    qtx11extras
    ffmpegthumbnailer
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${gst_all_1.gstreamer.dev}/include/gstreamer-1.0"
    "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0"
  ];

  cmakeFlags = [
    "-DVERSION=${version}"
  ];

  strictDeps = true;

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ mpv ffmpeg ffmpegthumbnailer gst_all_1.gstreamer gst_all_1.gst-plugins-base ]}"
  ];

  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "Full-featured video player supporting playing local and streaming media in multiple video formats";
    homepage = "https://github.com/linuxdeepin/deepin-movie-reborn";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
