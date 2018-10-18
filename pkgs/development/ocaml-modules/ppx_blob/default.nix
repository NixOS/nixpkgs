{ stdenv, fetchurl, ocaml, findlib, dune, alcotest
, ocaml-migrate-parsetree
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ppx_blob-${version}";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/johnwhitington/ppx_blob/releases/download/${version}/ppx_blob-${version}.tbz";
    sha256 = "1xmslk1mwdzhy1bydgsjlcb7h544c39hvxa8lywp8w72gaggjl16";
  };

  unpackCmd = "tar xjf $curSrc";

  buildInputs = [ ocaml findlib dune alcotest ocaml-migrate-parsetree ];

  buildPhase = "dune build -p ppx_blob";

  doCheck = true;
  checkPhase = "dune runtest -p ppx_blob";

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    homepage = https://github.com/johnwhitington/ppx_blob;
    description = "OCaml ppx to include binary data from a file as a string";
    license = licenses.unlicense;
  };
}
