{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_core, ppx_deriving, ppx_driver
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_type_conv-133.33.02+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_type_conv-113.33.02+4.03.tar.gz;
    sha256 = "0y7hsh152gcj89i6cr3b9kxgdnb2sx8vhaq2bdvbcc9zrirwq4d2";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_deriving ];
  propagatedBuildInputs = [ ppx_core ppx_driver ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
