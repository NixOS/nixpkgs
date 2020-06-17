{ lib, fetchurl, ocaml, buildDunePackage }:

if lib.versionAtLeast ocaml.version "4.08"
then throw "earley is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
  version = "2.0.0";
  pname = "earley";
  src = fetchurl {
    url = "https://github.com/rlepigre/ocaml-earley/releases/download/${version}/earley-${version}.tbz";
    sha256 = "1kjr0wh3lji7f493kf48rphxnlv3sygj5a8rmx9z3xkpbd7aqyyw";
  };

  minimumOCamlVersion = "4.03";

  meta = {
    description = "Parser combinators based on Earley Algorithm";
    license = lib.licenses.cecill-b;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/rlepigre/ocaml-earley";
  };
}
