{ lib, fetchurl, ocaml, buildDunePackage, benchmark }:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "rope is not available for OCaml ${ocaml.version}"

buildDunePackage rec {
  pname = "rope";
  version = "0.6.2";
  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/Chris00/ocaml-rope/releases/download/${version}/rope-${version}.tbz";
    sha256 = "15cvfa0s1vjx7gjd07d3fkznilishqf4z4h2q5f20wm9ysjh2h2i";
  };

  buildInputs = [ benchmark ] ;

  meta = {
    homepage = "https://github.com/Chris00/ocaml-rope";
    description = "Ropes (“heavyweight strings”) in OCaml";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ ];
  };
}
