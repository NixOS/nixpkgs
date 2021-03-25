{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   version = "2.1.0";

   useDune2 = true;

   minimumOCamlVersion = "4.02";

   src = fetchurl {
     url = "https://github.com/ocaml-ppx/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
     sha256 = "07x7lm45kny0mi0fjvzw51445brm0dgy099cw0gpyly0wj77hyrq";
   };

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = lib.licenses.lgpl21;
     maintainers = with lib.maintainers; [ vbgl sternenseemann ];
     homepage = "https://github.com/ocaml-ppx/ocaml-migrate-parsetree";
   };
}
