<<<<<<< HEAD
{ lib, fetchFromGitHub, buildDunePackage, dune-configurator }:

buildDunePackage rec {
  pname = "parmap";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "rdicosmo";
    repo = pname;
    rev = version;
    hash = "sha256-tBu7TGtDOe5FbxLZuz6nl+65aN9FHIngq/O4dJWzr3Q=";
=======
{ lib, fetchurl, buildDunePackage, dune-configurator }:

buildDunePackage rec {
  pname = "parmap";
  version = "1.2.4";

  src = fetchurl {
    url = "https://github.com/rdicosmo/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    sha256 = "sha256-BTkSEjIK3CVNloJACFo6eQ6Ob9o/cdrA9xuv87NKas4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  minimalOCamlVersion = "4.03";

  buildInputs = [
    dune-configurator
  ];

  doCheck = false; # prevent running slow benchmarks

  meta = with lib; {
    description = "Library for multicore parallel programming";
    downloadPage = "https://github.com/rdicosmo/parmap";
    homepage = "https://rdicosmo.github.io/parmap";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
