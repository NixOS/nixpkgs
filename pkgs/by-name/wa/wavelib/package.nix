{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "wavelib";
  version = "0-unstable-2025-12-12";

  src = fetchFromGitHub {
    owner = "rafat";
    repo = "wavelib";
    rev = "7f61bf592f3c470b2a7d8199431fde821d7253ac";
    hash = "sha256-M8HnyZ/ARnF7D7GuTx7vhuaJtpQVl5sV2qBe0LBynW4=";
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
