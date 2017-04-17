{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_tools, ppx_inline_test
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_bench-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_bench-113.33.00+4.03.tar.gz;
    sha256 = "00iv0p3cni4r7iimwm04bjg2hzvlvdb0b1kynjw2xav64xc29q01";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_tools ];
  propagatedBuildInputs = [ ppx_inline_test ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
