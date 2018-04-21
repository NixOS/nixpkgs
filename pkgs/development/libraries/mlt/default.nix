{ stdenv, fetchFromGitHub, fetchurl, makeWrapper
, SDL, ffmpeg, frei0r, libjack2, libdv, libsamplerate
, libvorbis, libxml2, movit, pkgconfig, sox
, gtk2
}:

stdenv.mkDerivation rec {
  name = "mlt-${version}";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "0b2fq0819r7n141l6hhr66hpayqqcmjr2yxw9azxkapg1h0div6q";
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

    # Remove an unnecessary reference to movit.dev.
    s=${movit.dev}/include
    t=$(for ((i = 0; i < ''${#s}; i++)); do echo -n X; done)
    sed -i $out/lib/mlt/libmltopengl.so -e "s|$s|$t|g"
  '';

  meta = with stdenv.lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = https://www.mltframework.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.tohl ];
    platforms = platforms.linux;
  };
}
