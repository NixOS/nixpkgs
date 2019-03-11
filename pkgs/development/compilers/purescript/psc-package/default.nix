{ haskellPackages, mkDerivation, fetchFromGitHub, lib }:

with lib;

mkDerivation rec {
  pname = "psc-package";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "purescript";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zadbph1vha3b5hvmjvs138dcwbab49f3v63air1l6r4cvpb6831";
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
