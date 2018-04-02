{ haskellPackages, mkDerivation, fetchFromGitHub, lib }:

with lib;

mkDerivation rec {
  pname = "psc-package";
  version = "0.3.2-pre";

  src = fetchFromGitHub {
    owner = "purescript";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vriyvq0mad3px4lhbqg6xrym2z6wnhr81101mx8cg1lgql1wgwk";
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
