{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gnugrep,
  binutils,
  makeBinaryWrapper,
  php,
  testers,
  phpPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phpspy";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "adsr";
    repo = "phpspy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QphoDdnSFPVRvEro0WDUC/yRsOf4I5p5BpHq32olqJI=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/adsr/phpspy/commit/8854e60ac38cfd2455d4a3d797f283eb3940cb7b.patch";
      hash = "sha256-IMO9GV0Z8PDEAVhLevg5jGh/PHcbNq3f3fMGFaKoLL4=";
    })
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    php.unwrapped
  ];

  env.USE_ZEND = 1;

  installPhase = ''
    runHook preInstall

    install -Dt "$out/bin" phpspy stackcollapse-phpspy.pl

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/phpspy" \
      --prefix PATH : "${
        lib.makeBinPath [
          gnugrep
          # for objdump
          binutils
        ]
      }"
  '';

  passthru.tests.version = testers.testVersion {
    version = "v${finalAttrs.version}";
    package = phpPackages.phpspy;
    command = "phpspy -v";
  };

  meta = with lib; {
    description = "Low-overhead sampling profiler for PHP";
    homepage = "https://github.com/adsr/phpspy";
    license = licenses.mit;
    mainProgram = "phpspy";
    maintainers = with maintainers; [ gaelreyrol ];
    platforms = [ "x86_64-linux" ];
  };
})
