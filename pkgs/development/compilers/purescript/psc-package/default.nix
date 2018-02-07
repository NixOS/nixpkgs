{ haskellPackages, mkDerivation, fetchFromGitHub, lib }:

with lib;

mkDerivation rec {
  pname = "psc-package";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "purescript";
    repo = pname;
    rev = "v${version}";
    sha256 = "15g0l8g8l6m5x4f73w68r9iav091x12b3wjxh0rx3ggnj093g6j1";
  };

  isLibrary = false;
  isExecutable = true;

  executableHaskellDepends = with haskellPackages; [
    aeson aeson-pretty optparse-applicative system-filepath turtle
  ];

  description = "An experimental package manager for PureScript";
  license = licenses.bsd3;
  maintainers = with lib.maintainers; [ profpatsch ];
}
