{ stdenv, fetchurl, ocaml, jbuilder, findlib, sexplib, ocplib-endian }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-cstruct-${version}";
  version = "3.0.2";
  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-${version}.tbz";
    sha256 = "03caxcyzfjmbnnwa15zy9s1ckkl4sc834d1qkgi4jcs3zqchvd8z";
  };

  unpackCmd = "tar -xjf $curSrc";

  buildInputs = [ ocaml jbuilder findlib ];

  propagatedBuildInputs = [ sexplib ocplib-endian ];

  buildPhase = "jbuilder build -p cstruct";

  inherit (jbuilder) installPhase;

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = stdenv.lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
