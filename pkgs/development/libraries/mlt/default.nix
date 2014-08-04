{ stdenv, fetchurl, SDL, ffmpeg, frei0r, jack2, libdv, libsamplerate
, libvorbis, libxml2, makeWrapper, movit, pkgconfig, qt, sox
}:

stdenv.mkDerivation rec {
  name = "mlt-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/mltframework/mlt/archive/v${version}.tar.gz";
    sha256 = "0vk1i2yrny6dbip4aha25ibgv4m2rdhpxmz6a74q9wz1cgzbb766";
  };

  buildInputs = [
    SDL ffmpeg frei0r jack2 libdv libsamplerate libvorbis libxml2
    makeWrapper movit pkgconfig qt sox
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
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
