{ haskellPackages, mkDerivation, fetchFromGitHub, lib }:

with lib;

mkDerivation rec {
  pname = "psc-package";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "purescript";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zpzcyh82xl0grvgcj8b7yzh053i9z94kbym5qrv413pcx7w50cm";
  };

  isLibrary = false;
  isExecutable = true;

  executableHaskellDepends = with haskellPackages; [
    aeson aeson-pretty optparse-applicative system-filepath turtle
  ];

  description = "An experimental package manager for PureScript";
  license = licenses.bsd3;
  maintainers = with lib.maintainers; [ Profpatsch ];
}
