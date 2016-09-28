{ stdenv, fetchFromGitHub, makeWrapper
, SDL, ffmpeg, frei0r, libjack2, libdv, libsamplerate
, libvorbis, libxml2, movit, pkgconfig, sox
, gtk2
}:

stdenv.mkDerivation rec {
  name = "mlt-${version}";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "17jwz1lf9ilaxvgvhg7z86dhcsk95m4wlszy4gn7wab2ns5zhdm7";
  };

  buildInputs = [
    SDL ffmpeg frei0r libjack2 libdv libsamplerate libvorbis libxml2
    makeWrapper movit pkgconfig sox
    gtk2
  ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [
    "--avformat-swscale" "--enable-gpl" "--enable-gpl" "--enable-gpl3"
    "--enable-opengl"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/melt --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1
  '';

  meta = with stdenv.lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = http://www.mltframework.org/;
    license = licenses.gpl3;
    maintainers = [ maintainers.tohl ];
    platforms = platforms.linux;
  };
}
