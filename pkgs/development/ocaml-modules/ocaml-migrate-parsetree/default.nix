{ stdenv, fetchFromGitHub, buildDunePackage, result, ppx_derivers }:

buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   version = "1.4.0";

   src = fetchFromGitHub {
     owner = "ocaml-ppx";
     repo = pname;
     rev = "v${version}";
     sha256 = "0sv1p4615l8gpbah4ya2c40yr6fbvahvv3ks7zhrsgcwcq2ljyr2";
   };

   propagatedBuildInputs = [ ppx_derivers result ];

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = stdenv.lib.licenses.lgpl21;
     maintainers = [ stdenv.lib.maintainers.vbgl ];
     inherit (src.meta) homepage;
   };
}
