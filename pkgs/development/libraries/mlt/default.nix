{ stdenv, fetchFromGitHub, makeWrapper, pkgconfig
, SDL, ffmpeg, frei0r, libjack2, libdv, libsamplerate
, libvorbis, libxml2, movit, sox, qtbase, qtsvg, gtk2
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

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [
    SDL ffmpeg frei0r libjack2 libdv libsamplerate libvorbis libxml2
    movit qtbase qtsvg sox fftw vid-stab opencv3
    ladspa-sdk gtk2
  ];

  # Mostly taken from documentation previously hosted at:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  # Which may now be the installation docs here: https://www.mltframework.org/docs/install
  configureFlags = [
    "--enable-gpl"
    "--enable-gpl3"
    #"--avformat-swscale"
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
    homepage = https://www.mltframework.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ goibhniu tohl ];
    platforms = platforms.linux;
  };
}
