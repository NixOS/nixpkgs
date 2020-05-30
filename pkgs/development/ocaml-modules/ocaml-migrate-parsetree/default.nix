{ lib, fetchFromGitHub, buildDunePackage, result, ppx_derivers }:

buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   version = "1.7.3";

   src = fetchFromGitHub {
     owner = "ocaml-ppx";
     repo = pname;
     rev = "v${version}";
     sha256 = "0336vz0galjnsazbmkxjwdv1qvdqsx2rgrvp778xgq2fzasz45cx";
   };

   propagatedBuildInputs = [ ppx_derivers result ];

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = lib.licenses.lgpl21;
     maintainers = [ lib.maintainers.vbgl ];
     inherit (src.meta) homepage;
   };
}
