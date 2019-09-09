{ stdenv, mkDerivation, fetchFromGitHub, cmake, pkgconfig, qttools, qtx11extras,
  dtkcore, dtkwidget, ffmpeg, ffmpegthumbnailer, mpv, pulseaudio,
  libdvdnav, libdvdread, xorg, deepin }:

mkDerivation rec {
  pname = "deepin-movie-reborn";
  version = "3.2.24";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "16mxym7dm6qk90q2w7xqm62047rq0lirrjmnnpaxshzaww9gngkh";
  };

  outputs = [ "out" "dev" ];

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

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Deepin movie player";
    homepage = https://github.com/linuxdeepin/deepin-movie-reborn;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
