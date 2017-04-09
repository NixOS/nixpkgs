{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, fieldslib, ppx_deriving, ppx_type_conv
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_fields_conv-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_fields_conv-113.33.00+4.03.tar.gz;
    sha256 = "1wfi8pc0y7wjiscvawhfgbcfx7ypmikmyyagwhzw7jhnldljwrkg";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ];
  propagatedBuildInputs = [ fieldslib ppx_deriving ppx_type_conv ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
