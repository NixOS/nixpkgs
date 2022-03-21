{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   version = "2.3.0";

   useDune2 = true;

   minimalOCamlVersion = "4.02";

   src = fetchurl {
     url = "https://github.com/ocaml-ppx/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
     sha256 = "sha256:02mzh1rcvc2xpq4iz01z7kvzsgxns3774ggxi96f147i8yr2d08h";
   };

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = lib.licenses.lgpl21;
     maintainers = with lib.maintainers; [ vbgl sternenseemann ];
     homepage = "https://github.com/ocaml-ppx/ocaml-migrate-parsetree";
   };
}
