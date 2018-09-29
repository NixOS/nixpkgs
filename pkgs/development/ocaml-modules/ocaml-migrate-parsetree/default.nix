{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, dune, result }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "ocaml-migrate-parsetree is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
   name = "ocaml${ocaml.version}-ocaml-migrate-parsetree-${version}";
   version = "1.0.11";

   src = fetchFromGitHub {
     owner = "ocaml-ppx";
     repo = "ocaml-migrate-parsetree";
     rev = "v${version}";
     sha256 = "05kbgs9n1x64fk6g3wbjnwjd17w10k3k8dzglnc45xg4hr7z651n";
   };

   buildInputs = [ ocaml findlib ocamlbuild dune ];
   propagatedBuildInputs = [ result ];

   inherit (dune) installPhase;

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = stdenv.lib.licenses.lgpl21;
     maintainers = [ stdenv.lib.maintainers.vbgl ];
     inherit (src.meta) homepage;
     inherit (ocaml.meta) platforms;
   };
}
