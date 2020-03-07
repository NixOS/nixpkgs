{ stdenv, fetchFromGitHub, makeWrapper
, SDL, ffmpeg, frei0r, libjack2, libdv, libsamplerate
, libvorbis, libxml2, movit, pkgconfig, sox
, gtk2
}:

stdenv.mkDerivation rec {
  pname = "mlt";
  version = "6.20.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "14kayzas2wisyw0z27qkcm4qnxbdb7bqa0hg7gaj5kbm3nvsnafk";
  };

  buildInputs = [
    SDL ffmpeg frei0r libjack2 libdv libsamplerate libvorbis libxml2
    makeWrapper movit pkgconfig sox
    gtk2
  ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [
    "--avformat-swscale" "--enable-gpl" "--enable-gpl3" "--enable-opengl"
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
    maintainers = with maintainers; [ tohl peti ];
    platforms = platforms.linux;
  };
}
