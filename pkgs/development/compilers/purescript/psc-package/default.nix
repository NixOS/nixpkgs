{ haskellPackages, mkDerivation, fetchFromGitHub, lib }:

with lib;

mkDerivation rec {
  pname = "psc-package";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "purescript";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pbgijglyqrm998a6z5ahp4phd72crzr3s8vq17a9dz3i0a9hcj5";
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
