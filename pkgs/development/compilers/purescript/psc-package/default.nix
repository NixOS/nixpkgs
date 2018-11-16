{ haskellPackages, mkDerivation, fetchFromGitHub, lib }:

with lib;

mkDerivation rec {
  pname = "psc-package";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "purescript";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xvnmpfj4c6h4gmc2c3d4gcs44527jrgfl11l2fs4ai1mc69w5zg";
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
