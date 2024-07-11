{ lib, fetchurl, buildDunePackage, ocaml }:

lib.throwIf (lib.versionAtLeast ocaml.version "5.1")
  "ocaml-migrate-parsetree is not available for OCaml ${ocaml.version}"

buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   version = "2.4.0";

   minimalOCamlVersion = "4.02";

   src = fetchurl {
     url = "https://github.com/ocaml-ppx/${pname}/releases/download/${version}/${pname}-${version}.tbz";
     sha256 = "sha256-7EnEUtwzemIFVqtoK/AZi/UBglULUC2PsjClkSYKpqQ=";
   };

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = lib.licenses.lgpl21;
     maintainers = with lib.maintainers; [ vbgl sternenseemann ];
     homepage = "https://github.com/ocaml-ppx/ocaml-migrate-parsetree";
   };
}
