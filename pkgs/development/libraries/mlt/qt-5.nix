{ stdenv, fetchFromGitHub, SDL, ffmpeg, frei0r, libjack2, libdv, libsamplerate
, libvorbis, libxml2, makeWrapper, movit, pkgconfig, sox, qtbase, qtsvg
, fftw, vid-stab, opencv3, ladspa-sdk
}:

let inherit (stdenv.lib) getDev; in

stdenv.mkDerivation rec {
  name = "mlt-${version}";
  version = "6.12.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "0pzm3mjbbdl2rkbswgyfkx552xlxh2qrwzsi2a4dicfr92rfgq6w";
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

  # mlt is unable to cope with our multi-prefix Qt build
  # because it does not use CMake or qmake.
  NIX_CFLAGS_COMPILE = [ "-I${getDev qtsvg}/include/QtSvg" ];

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
    homepage = https://www.mltframework.org/;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
