{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_tools, ppx_deriving, ppx_type_conv
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_compare-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_compare-113.33.00+4.03.tar.gz;
    sha256 = "07drgg6c857lsvxdjscdcb1ncdr5p3183spw32sbfcrbnr12nzys";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_tools ];
  propagatedBuildInputs = [ ppx_type_conv ppx_deriving ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
