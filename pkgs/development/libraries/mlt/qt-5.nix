{ stdenv, fetchurl, SDL, ffmpeg, frei0r, libjack2, libdv, libsamplerate
, libvorbis, libxml2, makeWrapper, movit, pkgconfig, sox, qtbase, qtsvg
}:

stdenv.mkDerivation rec {
  name = "mlt-${version}";
  version = "6.2.0";

  src = fetchurl {
    url = "https://github.com/mltframework/mlt/archive/v${version}.tar.gz";
    sha256 = "1zwzfgxrcbwkxnkiwv0a1rzxdnnaly90yyarl9wdw84nx11ffbnx";
  };

  buildInputs = [
    SDL ffmpeg frei0r libjack2 libdv libsamplerate libvorbis libxml2
    makeWrapper movit pkgconfig qtbase qtsvg sox
  ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [
    "--avformat-swscale" "--enable-gpl" "--enable-gpl" "--enable-gpl3"
    "--enable-opengl"
  ];

  CXXFLAGS = "-std=c++11";

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/melt --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1
  '';

  meta = with stdenv.lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = http://www.mltframework.org/;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
