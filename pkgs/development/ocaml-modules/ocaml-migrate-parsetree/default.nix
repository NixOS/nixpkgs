{ stdenv, fetchFromGitHub, buildDunePackage, result, ppx_derivers }:

buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   version = "1.2.0";

   src = fetchFromGitHub {
     owner = "ocaml-ppx";
     repo = pname;
     rev = "v${version}";
     sha256 = "16kas19iwm4afijv3yxd250s08absabmdcb4yj57wc8r4fmzv5dm";
   };

   propagatedBuildInputs = [ ppx_derivers result ];

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = stdenv.lib.licenses.lgpl21;
     maintainers = [ stdenv.lib.maintainers.vbgl ];
     inherit (src.meta) homepage;
   };
}
