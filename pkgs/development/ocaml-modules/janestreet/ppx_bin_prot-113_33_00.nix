{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, bin_prot, ppx_deriving, ppx_tools, ppx_type_conv
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_bin_prot-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_bin_prot-113.33.00+4.03.tar.gz;
    sha256 = "1xw1yjgnd5ny1cq0n6rbsdaywyzq2n0jwg4gjsxv14dhv0alav36";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_tools ];
  propagatedBuildInputs = [ bin_prot ppx_deriving ppx_type_conv ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
