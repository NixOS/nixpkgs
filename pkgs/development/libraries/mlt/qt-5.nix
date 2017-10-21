{ stdenv, fetchurl, SDL, ffmpeg, frei0r, libjack2, libdv, libsamplerate
, libvorbis, libxml2, makeWrapper, movit, pkgconfig, sox, qtbase, qtsvg
, fftw, vid-stab, opencv3, ladspa-sdk
}:

stdenv.mkDerivation rec {
  name = "mlt-${version}";
  version = "6.4.1";

  src = fetchurl {
    url = "https://github.com/mltframework/mlt/archive/v${version}.tar.gz";
    sha256 = "10m3ry0b2pvqx3bk34qh5dq337nn8pkc2gzfyhsj4nv9abskln47";
  };

  buildInputs = [
    SDL ffmpeg frei0r libjack2 libdv libsamplerate libvorbis libxml2
    makeWrapper movit pkgconfig qtbase qtsvg sox fftw vid-stab opencv3
    ladspa-sdk
  ];

  outputs = [ "out" "dev" ];

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

    # Remove an unnecessary reference to movit.dev.
    s=${movit.dev}/include
    t=$(for ((i = 0; i < ''${#s}; i++)); do echo -n X; done)
    sed -i $out/lib/mlt/libmltopengl.so -e "s|$s|$t|g"

    # Remove an unnecessary reference to movit.dev.
    s=${qtbase.dev}/include
    t=$(for ((i = 0; i < ''${#s}; i++)); do echo -n X; done)
    sed -i $out/lib/mlt/libmltqt.so -e "s|$s|$t|g"
  '';

  passthru = {
    inherit ffmpeg;
  };

  meta = with stdenv.lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = http://www.mltframework.org/;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
