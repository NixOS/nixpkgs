{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  menhir,
  containers,
  containers-data,
  iter,
  num,
}:
buildDunePackage {
  pname = "nunchaku";
  version = "0.6-unstable-2026-07-11";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitHub {
    owner = "nunchaku-inria";
    repo = "nunchaku";
    rev = "d23a876d788e9d7fb59ec58a003cf1d0765723f1";
    hash = "sha256-7qpT/m22Z1LycQKXv08JYKpfafUX1eo/tDyek14AkFo=";
  };

  nativeBuildInputs = [ menhir ];
  buildInputs = [
    containers
    containers-data
    iter
    num
  ];

  meta = {
    description = "A counter-example finder for higher-order logic";
    homepage = "https://nunchaku-inria.github.io/nunchaku/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sempiternal-aurora ];
    mainProgram = "nunchaku";
  };
}
