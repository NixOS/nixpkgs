{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "wavelib";
  version = "0-unstable-2025-09-21";

  src = fetchFromGitHub {
    owner = "rafat";
    repo = "wavelib";
    rev = "8551b35834c0b15e81de730ec9a711d948229c37";
    hash = "sha256-tW7LL8RDEPeIdeMqzScASWMu8stLfKtMjfmO8P0slpY=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    runHook preCheck
    Bin/Release/wavelibLibTests
    runHook postCheck
  '';

  # Don't install the test binary
  postInstall = ''
    rm -r $out/bin
  '';

  meta = {
    description = "C Implementation of Discrete Wavelet Transform (DWT,SWT and MODWT)";
    homepage = "https://github.com/rafat/wavelib";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ rowanG077 ];
  };
}
