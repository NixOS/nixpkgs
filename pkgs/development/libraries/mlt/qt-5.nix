{ config
, lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, which
, wrapQtAppsHook
, SDL2
, ffmpeg
, fftw
, frei0r
, libdv
, libjack2
, libsamplerate
, libvorbis
, libxml2
, movit
, opencv4
, qtbase
, qtsvg
, rtaudio
, rubberband
, sox
, vid-stab
, darwin
, cudaSupport ? config.cudaSupport or false
, cudaPackages ? { }
, jackrackSupport ? stdenv.isLinux
, ladspa-sdk
, ladspaPlugins
, pythonSupport ? false
, python3
, swig
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "mlt";
  version = "7.16.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    hash = "sha256-Ed9CHaeJ8Rkrvfq/dZVOn/5lhHLH7B6A1Qf2xOQfWik=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    wrapQtAppsHook
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ] ++ lib.optionals pythonSupport [
    python3
    swig
  ];

  buildInputs = [
    SDL2
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
    qtbase
    qtsvg
    rtaudio
    rubberband
    sox
    vid-stab
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Accelerate
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ] ++ lib.optionals jackrackSupport [
    ladspa-sdk
    ladspaPlugins
  ];

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DMOD_OPENCV=ON"
  ] ++ lib.optionals pythonSupport [
    "-DSWIG_PYTHON=ON"
  ];

  qtWrapperArgs = [
    "--prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1"
  ] ++ lib.optionals jackrackSupport [
    "--prefix LADSPA_PATH : ${ladspaPlugins}/lib/ladspa"
  ];

  postFixup = ''
    substituteInPlace "$dev"/lib/pkgconfig/mlt-framework-7.pc \
      --replace '=''${prefix}//' '=/'
  '';

  passthru = {
    inherit ffmpeg;
  };

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Open source multimedia framework, designed for television broadcasting";
    homepage = "https://www.mltframework.org/";
    license = with licenses; [ lgpl21Plus gpl2Plus ];
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
