{ haskellPackages, mkDerivation, fetchFromGitHub, lib }:

with lib;

mkDerivation rec {
  pname = "psc-package";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "purescript";
    repo = pname;
    rev = "v${version}";
    sha256 = "0536mijma61khldnpbdviq2vvpfzzz7w8bxr59mvr19i10njdq0y";
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
