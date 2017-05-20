{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, typerep, ppx_tools, ppx_type_conv, ppx_deriving
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_typerep_conv-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_typerep_conv-113.33.00+4.03.tar.gz;
    sha256 = "0k03wp07jvv3zpsm8n5hvskd5iagjvpcpxj9rpj012nia5iqfaj6";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_tools ];
  propagatedBuildInputs = [ ppx_type_conv typerep ppx_deriving ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
