{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_sexp_conv, ppx_here
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_sexp_message-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_sexp_message-113.33.00+4.03.tar.gz;
    sha256 = "01vrm8dk413gh19i2y6ffpsmscjhayp3asn5hcbcflxsvlaf4klx";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ];
  propagatedBuildInputs = [ ppx_here ppx_sexp_conv ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
