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
}:

stdenv.mkDerivation rec {
  pname = "mlt";
  version = "7.18.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
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
