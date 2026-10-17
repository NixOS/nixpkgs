{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  SDL,
}:

stdenv.mkDerivation {
  pname = "vix";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "BatchDrake";
    repo = "vix";
    rev = "824b6755157a0f7430a0be0af454487d1492204d";
    hash = "sha256-P/D+4Cd1GYCmaZ4xeKS/wOUY+qNoBdGvGU/nKZUWCvg=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    (lib.enableFeature (!stdenv.hostPlatform.isDarwin) "sdltest")
  ];

  buildInputs = [ SDL ];

  meta = {
    description = "Visual Interface heXadecimal dump";
    homepage = "http://actinid.org/vix/";
    license = lib.licenses.gpl3;
    mainProgram = "vix";
    # sys/io.h missing on other platforms
    platforms = [ "x86_64-linux" ];
  };
}
