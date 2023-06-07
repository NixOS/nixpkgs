{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, runtimeShell
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
}:

stdenv.mkDerivation rec {
  pname = "deepin-movie-reborn";
  version = "5.10.23";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-0m8wYRQGsdN4zpnHUJKCfF05SdvTauRSp6gCu2F9ZAI";
  };

  patches = [
    (fetchpatch {
      name = "feat-rewrite-libPath-to-read-LD_LIBRARY_PATH.patch";
      url = "https://github.com/linuxdeepin/deepin-movie-reborn/commit/432bf452ed244c256e99ecaf80bb6a0eef9b4a74.patch";
      sha256 = "sha256-5hRQ8D9twBKgouVpIBa1pdAGk0lI/wEdQaHBBHFCZBA";
    })
  ];

  postPatch = ''
    # https://github.com/linuxdeepin/deepin-movie-reborn/pull/198
    substituteInPlace src/common/diskcheckthread.cpp \
      --replace "/usr/include/linux/cdrom.h" "linux/cdrom.h"
    substituteInPlace src/widgets/toolbox_proxy.cpp \
      --replace "/bin/bash" "${runtimeShell}"

    # libdmr always assume that these libraries exist
    # otherwise it will lead to coredump
    # This affects the preview plugin for dde-file-manager

    substituteInPlace src/libdmr/{filefilter.cpp,playlist_model.cpp,gstutils.cpp} \
      --replace 'LibraryLoader::libPath("libavcodec.so")' '"${lib.getLib ffmpeg}/lib/libavcodec.so"' \
      --replace 'LibraryLoader::libPath("libavformat.so")' '"${lib.getLib ffmpeg}/lib/libavformat.so"' \
      --replace 'LibraryLoader::libPath("libavutil.so")' '"${lib.getLib ffmpeg}/lib/libavutil.so"' \
      --replace 'LibraryLoader::libPath("libffmpegthumbnailer.so")' '"${lib.getLib ffmpegthumbnailer}/lib/libffmpegthumbnailer.so"' \
      --replace 'LibraryLoader::libPath("libgstreamer-1.0.so")' '"${lib.getLib gst_all_1.gstreamer}/lib/libgstreamer-1.0.so"' \
      --replace 'LibraryLoader::libPath("libgstpbutils-1.0.so")' '"${lib.getLib gst_all_1.gst-plugins-base}/lib/libgstpbutils-1.0.so"'
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
    elfutils.dev
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
    zstd.dev
    mpv
    gtest
    libpulseaudio
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
  ]);

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
