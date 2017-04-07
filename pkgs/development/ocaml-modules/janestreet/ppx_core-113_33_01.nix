{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg
, ppx_tools
}:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_core-133.33.01+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/ppx_core-113.33.01+4.03.tar.gz;
    sha256 = "0ibww4lx87lmn164mxczl3sa7ldwc7g1zi4m9c4vllsv004iyffl";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ppx_tools ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
