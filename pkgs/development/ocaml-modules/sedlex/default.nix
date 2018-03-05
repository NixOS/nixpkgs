{ stdenv, fetchzip, ocaml, findlib, gen, ppx_tools_versioned }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "sedlex is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-sedlex-${version}";
  version = "1.99.4";

  src = fetchzip {
    url = "https://github.com/alainfrisch/sedlex/archive/v${version}.tar.gz";
    sha256 = "1b7nqxyfcz8i7m4b8zil2rn6ygh2czy26f9v64xnxn8r0hy9sh1m";
  };

  buildInputs = [ ocaml findlib ppx_tools_versioned ];

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
