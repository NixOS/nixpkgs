{ lib, stdenv, fetchFromGitHub, makeWrapper
, SDL, ffmpeg_4, frei0r, libjack2, libdv, libsamplerate, libexif
, libvorbis, libxml2, movit, pkg-config, sox, fftw, opencv4, SDL2
, gtk2, gitUpdater, libebur128, rubberband
, jack2, ladspa-sdk, swig, which, ncurses
, enablePython ? false, python3
}:

stdenv.mkDerivation rec {
  pname = "mlt";
  version = "6.26.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "FPXROiX7A6oB1VMipw3slyhk7q4fO6m9amohnC67lnA=";
  };

  buildInputs = [
    SDL ffmpeg_4 frei0r libjack2 libdv libsamplerate libvorbis libxml2.dev
    movit sox libexif gtk2 fftw libebur128 opencv4 SDL2 jack2
    ladspa-sdk rubberband
  ] ++ lib.optional enablePython ncurses;

  nativeBuildInputs = [ pkg-config makeWrapper which ]
  ++ lib.optionals enablePython [ python3 swig ];

  strictDeps = true;

  # Mostly taken from:
  # http://www.kdenlive.org/user-manual/downloading-and-installing-kdenlive/installing-source/installing-mlt-rendering-engine
  configureFlags = [
    "--avformat-swscale" "--enable-gpl" "--enable-gpl3" "--enable-opengl"
  ] ++ lib.optional enablePython "--swig-languages=python";

  enableParallelBuilding = true;
  outPythonPath = lib.optionalString enablePython "$(toPythonPath $out)";

  postInstall = ''
    wrapProgram $out/bin/melt --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1

    # Remove an unnecessary reference to movit.dev.
    s=${movit.dev}/include
    t=$(for ((i = 0; i < ''${#s}; i++)); do echo -n X; done)
    sed -i $out/lib/mlt/libmltopengl.so -e "s|$s|$t|g"
  '' + lib.optionalString enablePython ''
    mkdir -p ${outPythonPath}/mlt
    cp -a src/swig/python/_mlt.so ${outPythonPath}/mlt/
    cp -a src/swig/python/mlt.py ${outPythonPath}/mlt/__init__.py
    sed -i ${outPythonPath}/mlt/__init__.py -e "s|return importlib.import_module('_mlt')|return importlib.import_module('mlt._mlt')|g"
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = "https://www.mltframework.org";
    license = with licenses; [ gpl3Only gpl2Only lgpl21Only ];
    maintainers = with maintainers; [ peti ];
    platforms = platforms.linux;
  };
}
