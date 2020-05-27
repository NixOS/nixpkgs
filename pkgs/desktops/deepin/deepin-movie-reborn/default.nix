{ stdenv
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, qttools
, qtx11extras
, dtkwidget
, qt5integration
, glib
, ffmpeg_3
, ffmpegthumbnailer
, gsettings-qt
, mpv
, pulseaudio
, libdvdnav
, libdvdread
, xorg
, deepin
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "deepin-movie-reborn";
  version = "5.7.6.29";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1780hazkgz4imiy3d8pl22laasvys46rddh7ijzwsvi8b5dx02wm";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    glib
    wrapGAppsHook
    deepin.setupHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    ffmpeg_3
    ffmpegthumbnailer
    gsettings-qt
    libdvdnav
    libdvdread
    mpv
    pulseaudio
    qtx11extras
    xorg.libXdmcp
    xorg.libXtst
    xorg.libpthreadstubs
    xorg.xcbproto
  ];

  NIX_LDFLAGS = "-ldvdnav";

  postPatch = ''
    searchHardCodedPaths  # debugging

    substituteInPlace src/libdmr/libdmr.pc.in \
      --replace /usr $out \
      --replace 'libdir=''${prefix}/' 'libdir='

    substituteInPlace src/CMakeLists.txt \
      --replace /usr $out

    substituteInPlace src/deepin-movie.desktop \
      --replace "Exec=deepin-movie" "Exec=$out/bin/deepin-movie"
  '';

  dontWrapQtApps = true;

  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}

    gappsWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
    )
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
    searchHardCodedPaths $dev  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Deepin movie player";
    homepage = "https://github.com/linuxdeepin/deepin-movie-reborn";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
