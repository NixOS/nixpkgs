{ stdenv, fetchFromGitHub, cmake, pkgconfig, qttools, qtx11extras,
  dtkcore, dtkwidget, ffmpeg, ffmpegthumbnailer, mpv, pulseaudio,
  libdvdnav, libdvdread, xorg, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-movie-reborn";
  version = "3.2.22.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1qh079j4c2n33z0ykv87af9vfkmdxxrv6dy54wdqdpr7vrhn89gb";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    qttools
  ];

  buildInputs = [
    dtkcore
    dtkwidget
    ffmpeg
    ffmpegthumbnailer
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
    sed -i src/CMakeLists.txt -e "s,/usr/lib/dtk2,${dtkcore}/lib/dtk2,"
    sed -i src/libdmr/libdmr.pc.in -e "s,/usr,$out," -e 's,libdir=''${prefix}/,libdir=,'
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin movie player";
    homepage = https://github.com/linuxdeepin/deepin-movie-reborn;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
