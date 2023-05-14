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
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
