<<<<<<< HEAD
{ config
, lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, which
, ffmpeg
, fftw
, frei0r
, libdv
, libjack2
, libsamplerate
, libvorbis
, libxml2
, makeWrapper
, movit
, opencv4
, rtaudio
, rubberband
, sox
, vid-stab
, darwin
, cudaSupport ? config.cudaSupport
, cudaPackages ? { }
, enableJackrack ? stdenv.isLinux
, ladspa-sdk
, ladspaPlugins
, enablePython ? false
, python3
, swig
, enableQt ? false
, libsForQt5
, enableSDL1 ? stdenv.isLinux
, SDL
, enableSDL2 ? true
, SDL2
, gitUpdater
=======
{ lib, stdenv, fetchFromGitHub, makeWrapper
, SDL, ffmpeg_4, frei0r, libjack2, libdv, libsamplerate, libexif
, libvorbis, libxml2, movit, pkg-config, sox, fftw, opencv4, SDL2
, gtk2, gitUpdater, libebur128, rubberband
, jack2, ladspa-sdk, swig, which, ncurses
, enablePython ? false, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "mlt";
<<<<<<< HEAD
  version = "7.18.0";
=======
  version = "6.26.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3qvMuBr2w/gedTDIjG6ezatleXuQSnKX4SkBShzj6aw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    makeWrapper
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ] ++ lib.optionals enablePython [
    python3
    swig
  ] ++ lib.optionals enableQt [
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    ffmpeg
    fftw
    frei0r
    libdv
    libjack2
    libsamplerate
    libvorbis
    libxml2
    movit
    opencv4
    rtaudio
    rubberband
    sox
    vid-stab
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Accelerate
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ] ++ lib.optionals enableJackrack [
    ladspa-sdk
    ladspaPlugins
  ] ++ lib.optionals enableQt [
    libsForQt5.qtbase
    libsForQt5.qtsvg
  ] ++ lib.optionals enableSDL1 [
    SDL
  ] ++ lib.optionals enableSDL2 [
    SDL2
  ];

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DMOD_OPENCV=ON"
  ] ++ lib.optionals enablePython [
    "-DSWIG_PYTHON=ON"
  ];

  preFixup = ''
    wrapProgram $out/bin/melt \
      --prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1 \
      ${lib.optionalString enableJackrack "--prefix LADSPA_PATH : ${ladspaPlugins}/lib/ladspa"} \
      ${lib.optionalString enableQt "\${qtWrapperArgs[@]}"}

  '';

  postFixup = ''
    substituteInPlace "$dev"/lib/pkgconfig/mlt-framework-7.pc \
      --replace '=''${prefix}//' '=/'
  '';

  passthru = {
    inherit ffmpeg;
  };

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
<<<<<<< HEAD
    homepage = "https://www.mltframework.org/";
    license = with licenses; [ lgpl21Plus gpl2Plus ];
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
=======
    homepage = "https://www.mltframework.org";
    license = with licenses; [ gpl3Only gpl2Only lgpl21Only ];
    maintainers = with maintainers; [ peti ];
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
