{ stdenv, fetchurl, ocaml, findlib, topkg, ocamlbuild, opam }:

stdenv.mkDerivation {
  name = "ocaml-react-1.2.1";

  src = fetchurl {
    url = http://erratique.ch/software/react/releases/react-1.2.1.tbz;
    sha256 = "1aj8w79gdd9xnrbz7s5p8glcb4pmimi8jp9f439dqnf6ih3mqb3v";
  };

  unpackCmd = "tar xjf $src";
  buildInputs = [ ocaml findlib topkg ocamlbuild opam ];

  createFindlibDestdir = true;

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    homepage = http://erratique.ch/software/react;
    description = "Applicative events and signals for OCaml";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ z77z vbmithr gal_bolle];
  };
}
