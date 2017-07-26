{ haskellPackages, mkDerivation, fetchFromGitHub, lib }:

with lib;

mkDerivation rec {
  pname = "psc-package";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "purescript";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vid8vc8n8xj0qa4gnm1any9s18rdh7yn960vgix17r7a3bdndwb";
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
