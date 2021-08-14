{ lib
, fetchFromGitHub
, SDL
, ffmpeg
, frei0r
, libjack2
, libdv
, libsamplerate
, libvorbis
, libxml2
, movit
, pkg-config
, sox
, qtbase
, qtsvg
, fftw
, vid-stab
, opencv3
, ladspa-sdk
, genericUpdater
, common-updater-scripts
, ladspaPlugins
, mkDerivation
, which
}:

mkDerivation rec {
  pname = "mlt";
  version = "6.24.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "1my43ica2qax2622307dv4gn3w8hkchy643i9pq8r9yh2hd4pvs9";
  };

  buildInputs = [
    SDL
    ffmpeg
    frei0r
    libjack2
    libdv
    libsamplerate
    libvorbis
    libxml2
    movit
    pkg-config
    qtbase
    qtsvg
    sox
    fftw
    vid-stab
    opencv3
    ladspa-sdk
    ladspaPlugins
  ];

  nativeBuildInputs = [ which ];

  outputs = [ "out" "dev" ];

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [
    "--avformat-swscale"
    "--enable-gpl"
    "--enable-gpl3"
    "--enable-opengl"
  ];

  # mlt is unable to cope with our multi-prefix Qt build
  # because it does not use CMake or qmake.
  NIX_CFLAGS_COMPILE = "-I${lib.getDev qtsvg}/include/QtSvg";

  CXXFLAGS = "-std=c++11";

  qtWrapperArgs = [
    "--prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1"
    "--prefix LADSPA_PATH : ${ladspaPlugins}/lib/ladspa"
  ];

  postInstall = ''
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

  passthru.updateScript = genericUpdater {
    inherit pname version;
    versionLister = "${common-updater-scripts}/bin/list-git-tags ${src.meta.homepage}";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = "https://www.mltframework.org/";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
