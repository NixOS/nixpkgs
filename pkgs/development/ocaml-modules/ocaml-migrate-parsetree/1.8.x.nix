{ lib, fetchFromGitHub, buildDunePackage, ocaml, result, ppx_derivers }:

if lib.versionOlder "4.13" ocaml.version
then throw "ocaml-migrate-parsetree-1.8 is not available for OCaml ${ocaml.version}"
else

buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   version = "1.8.0";

   duneVersion = if lib.versionAtLeast ocaml.version "4.08" then "3" else "1";

   src = fetchFromGitHub {
     owner = "ocaml-ppx";
     repo = pname;
     rev = "v${version}";
     sha256 = "16x8sxc4ygxrr1868qpzfqyrvjf3hfxvjzmxmf6ibgglq7ixa2nq";
   };

   propagatedBuildInputs = [ ppx_derivers result ];

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = lib.licenses.lgpl21;
     maintainers = [ lib.maintainers.vbgl ];
     inherit (src.meta) homepage;
   };
}
