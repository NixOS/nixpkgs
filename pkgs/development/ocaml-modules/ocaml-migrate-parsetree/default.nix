{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, jbuilder, result }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "ocaml-migrate-parsetree is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
   name = "ocaml${ocaml.version}-ocaml-migrate-parsetree-${version}";
   version = "0.7";

   src = fetchFromGitHub {
     owner = "let-def";
     repo = "ocaml-migrate-parsetree";
     rev = "v${version}";
     sha256 = "142svvixhz153argd3khk7sr38dhiy4w6sck4766f8b48p41pp3m";
   };

   buildInputs = [ ocaml findlib ocamlbuild jbuilder ];
   propagatedBuildInputs = [ result ];

   installPhase = ''
     for p in *.install
     do
       ${jbuilder.installPhase} $p
     done
   '';

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = stdenv.lib.licenses.lgpl21;
     maintainers = [ stdenv.lib.maintainers.vbgl ];
     inherit (src.meta) homepage;
     inherit (ocaml.meta) platforms;
   };
}
