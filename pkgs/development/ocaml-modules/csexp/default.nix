{ lib, fetchurl, buildDunePackage, result }:

buildDunePackage rec {
  pname = "csexp";
  version = "1.4.0";

  useDune2 = true;

  minimumOCamlVersion = "4.02.3";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/csexp/releases/download/${version}/csexp-${version}.tbz";
    sha256 = "sha256-jj1vyofxAqEm3ui3KioNFG8QQ5xHIY38FJ1Rvz7fNk4=";
  };

  propagatedBuildInputs = [ result ];

  meta = with lib; {
    homepage = "https://github.com/ocaml-dune/csexp";
    description = "Minimal support for Canonical S-expressions";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
