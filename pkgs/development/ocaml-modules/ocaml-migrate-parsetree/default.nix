{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, jbuilder, result }:

stdenv.mkDerivation rec {
   name = "ocaml${ocaml.version}-ocaml-migrate-parsetree-${version}";
   version = "0.5";

   src = fetchFromGitHub {
     owner = "let-def";
     repo = "ocaml-migrate-parsetree";
     rev = "v${version}";
     sha256 = "023lnd3kxa3d4zgsvv0z2lyzhg05zcgagy18vaalimbza57wq83h";
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
