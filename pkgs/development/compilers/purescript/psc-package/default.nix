{ haskellPackages, mkDerivation, fetchFromGitHub, lib }:

with lib;

mkDerivation rec {
  pname = "psc-package";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "purescript";
    repo = pname;
    rev = "v${version}";
    sha256 = "165yax131rj1mdlqd28g6wcy1ps3k4w50z8gj9yc3nfs09dy0lab";
  };

  isLibrary = false;
  isExecutable = true;

  executableHaskellDepends = with haskellPackages; [
    aeson aeson-pretty either errors optparse-applicative
    system-filepath turtle
  ];

  description = "A package manager for PureScript based on package sets";
  license = licenses.bsd3;
  maintainers = with lib.maintainers; [ Profpatsch ];
}
