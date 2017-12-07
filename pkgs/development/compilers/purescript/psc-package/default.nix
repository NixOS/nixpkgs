{ haskellPackages, mkDerivation, fetchFromGitHub, lib }:

with lib;

mkDerivation rec {
  pname = "psc-package";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "purescript";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m1vcxa5zs4sqnnwgmxkhw1isdlmirp12yimn5345vwfvlxkc8kp";
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
