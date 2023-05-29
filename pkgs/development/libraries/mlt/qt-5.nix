{ config
, lib
, fetchFromGitHub
, cmake
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
, opencv4
, ladspa-sdk
, gitUpdater
, ladspaPlugins
, rubberband
, mkDerivation
, which
, cudaSupport ? config.cudaSupport or false
, cudaPackages ? {}
}:

mkDerivation rec {
  pname = "mlt";
  version = "7.16.0";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "mlt";
    rev = "v${version}";
    sha256 = "sha256-Ed9CHaeJ8Rkrvfq/dZVOn/5lhHLH7B6A1Qf2xOQfWik=";
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
    qtbase
    qtsvg
    sox
    fftw
    vid-stab
    opencv4
    ladspa-sdk
    ladspaPlugins
    rubberband
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_cudart
  ]);

  nativeBuildInputs = [
    cmake
    which
    pkg-config
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_nvcc
  ]);

  outputs = [ "out" "dev" ];

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DMOD_OPENCV=ON"
  ];

  qtWrapperArgs = [
    "--prefix FREI0R_PATH : ${frei0r}/lib/frei0r-1"
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
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
