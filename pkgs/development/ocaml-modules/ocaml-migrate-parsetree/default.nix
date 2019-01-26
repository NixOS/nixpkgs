{ stdenv, fetchFromGitHub, buildDunePackage, result }:

buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   version = "1.1.0";

   src = fetchFromGitHub {
     owner = "ocaml-ppx";
     repo = pname;
     rev = "v${version}";
     sha256 = "1d2n349d1cqm3dr09mwy5m9rfd4bkkqvri5i94wknpsrr35vnrr1";
   };

   propagatedBuildInputs = [ result ];

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = stdenv.lib.licenses.lgpl21;
     maintainers = [ stdenv.lib.maintainers.vbgl ];
     inherit (src.meta) homepage;
   };
}
