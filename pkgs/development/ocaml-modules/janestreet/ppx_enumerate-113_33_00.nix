{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_tools, ppx_deriving, ppx_type_conv
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_enumerate-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_enumerate-113.33.00+4.03.tar.gz;
    sha256 = "0b0kvdw6kids4yrzqq2h82gmnx1zfiahr82rrdbwiwkk4g0pxl93";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_tools ];
  propagatedBuildInputs = [ ppx_deriving ppx_type_conv ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
