{
  lib,
  stdenv,
  fetchFromGitHub,
  # Configure
  autoreconfHook,
  # Build binaries
  pkg-config,
  wrapGAppsHook3,
  # Build libraries
  gtk3,
  portaudio,
  fftwFloat,
  libjack2,
  python3,
  # Check Binaries
  xvfb-run,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tg-timer";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "xyzzy42";
    repo = "tg";
    tag = "v${finalAttrs.version}-tpiepho";
    hash = "sha256-9QeTjr/J0Y10YfPKEfYnciu5z2+hmmWFKLdw6CCS3hU=";
  };

  patches = [
    ./audio.patch
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    wrapGAppsHook3
    autoreconfHook
    pkg-config
    (python3.pythonOnBuildForHost.withPackages (p: [
      p.numpy
      p.matplotlib
      p.libtfr
      p.scipy
    ]))
  ];

  buildInputs = [
    gtk3
    portaudio
    fftwFloat
    libjack2
  ];

  enableParallelBuilding = true;

  doCheck = true;
  nativeCheckInputs = [
    xvfb-run
  ];
  checkPhase = ''
    runHook preCheck

    xvfb-run -s '-screen 0 800x600x24' \
    make -j "$NIX_BUILD_CORES" test

    runHook postCheck
  '';

  meta = {
    description = "for timing mechanical watches";
    homepage = "https://github.com/xyzzy42/tg";
    changelog = "https://github.com/xyzzy42/tg/releases/tag/v${finalAttrs.version}-tpiepho";
    license = lib.licenses.gpl2Plus;
    mainProgram = "tg-timer";
    maintainers = with lib.maintainers; [ RossSmyth ];
  };
})
