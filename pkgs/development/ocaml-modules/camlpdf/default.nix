{ stdenv, fetchgit, ocaml, findlib, ncurses }:

stdenv.mkDerivation rec {
  version = "2.2.1";
  name = "ocaml${ocaml.version}-camlpdf-${version}";
  src = fetchgit {
    url = https://github.com/johnwhitington/camlpdf.git;
    rev = "refs/tags/v${version}";
    sha256 = "0wa4rw8ccpb8xprslg88hbk352bi8bia4iffc22y55gkjr60f8gj";
  };

  buildInputs = [ ocaml findlib ncurses ];

  # Version number in META file is wrong
  patchPhase = ''
    patch -p 0 META <<EOF
    3c3
    < version="1.7.1"
    ---
    > version="${version}"
    EOF
  '';

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    description = "An OCaml library for reading, writing and modifying PDF files";
    homepage = https://github.com/johnwhitington/camlpdf;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [vbgl];
  };
}
