{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, dune }:

if !stdenv.lib.versionAtLeast ocaml.version "4.07"
then throw "lua-ml is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "lua-ml";
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "lindig";
    repo = pname;
    rev = "${version}";
    sha256 = "09lj6qykg15fdf65in7xdry0jcifcr8vqbvz85v12gwfckmmxjir";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  buildFlags = [ "lib" ];

  inherit (dune) installPhase;

  meta = {
    description = "An embeddable Lua 2.5 interpreter implemented in OCaml";
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
