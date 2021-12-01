{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   version = "2.2.0";

   useDune2 = true;

   minimalOCamlVersion = "4.02";

   src = fetchurl {
     url = "https://github.com/ocaml-ppx/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
     sha256 = "188v3z09bg4gyv80c138fa3a3j2w54w5gc4r1ajw7klr70yqz9mj";
   };

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = lib.licenses.lgpl21;
     maintainers = with lib.maintainers; [ vbgl sternenseemann ];
     homepage = "https://github.com/ocaml-ppx/ocaml-migrate-parsetree";
   };
}
