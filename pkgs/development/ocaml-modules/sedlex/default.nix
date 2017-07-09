{ stdenv, fetchzip, ocaml, findlib, gen, ppx_tools }:

assert stdenv.lib.versionAtLeast ocaml.version "4.02";

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-sedlex-${version}";
  version = "1.99.3";

  src = fetchzip {
    url = "http://github.com/alainfrisch/sedlex/archive/v${version}.tar.gz";
    sha256 = "1wghjy3qyj43ll1ikchlqy7fv2hxcn3ap9xgsscm2ch09d8dcv7y";
  };

  buildInputs = [ ocaml findlib ppx_tools ];

  propagatedBuildInputs = [ gen ];

  buildFlags = [ "all" "opt" ];

  createFindlibDestdir = true;

  dontStrip = true;

  meta = {
    homepage = https://github.com/alainfrisch/sedlex;
    description = "An OCaml lexer generator for Unicode";
    license = stdenv.lib.licenses.mit;
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
