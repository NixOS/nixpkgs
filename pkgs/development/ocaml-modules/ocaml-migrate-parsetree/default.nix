{ lib, fetchFromGitHub, buildDunePackage, result, ppx_derivers }:

buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   version = "1.5.0";

   src = fetchFromGitHub {
     owner = "ocaml-ppx";
     repo = pname;
     rev = "v${version}";
     sha256 = "0ms7nx7x16nkbm9rln3sycbzg6ad8swz8jw6bjndrill8bg3fipv";
   };

   propagatedBuildInputs = [ ppx_derivers result ];

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = lib.licenses.lgpl21;
     maintainers = [ lib.maintainers.vbgl ];
     inherit (src.meta) homepage;
   };
}
