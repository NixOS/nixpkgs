<<<<<<< HEAD
{ lib, fetchurl, buildDunePackage, liquidsoap }:

buildDunePackage rec {
  pname = "csexp";
  version = "1.5.2";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/csexp/releases/download/${version}/csexp-${version}.tbz";
    hash = "sha256-GhTdBLtDeaQZkCSFUGKMd5E6nAfzw1wTcLaWDml3h/8=";
  };

  minimalOCamlVersion = "4.03";

  passthru.tests = {
    inherit liquidsoap;
  };

  meta = with lib; {
    description = "Minimal support for Canonical S-expressions";
    homepage = "https://github.com/ocaml-dune/csexp";
    changelog = "https://github.com/ocaml-dune/csexp/raw/${version}/CHANGES.md";
=======
{ lib, fetchurl, buildDunePackage, result }:

buildDunePackage rec {
  pname = "csexp";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/csexp/releases/download/${version}/csexp-${version}.tbz";
    sha256 = "sha256-1gXkBl+pCliABEDvLzOi2TE5i/LCIGGorLffhFwKrAI=";
  };

  minimumOCamlVersion = "4.03";
  useDune2 = true;

  propagatedBuildInputs = [
    result
  ];

  meta = with lib; {
    homepage = "https://github.com/ocaml-dune/csexp/";
    description = "Minimal support for Canonical S-expressions";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
