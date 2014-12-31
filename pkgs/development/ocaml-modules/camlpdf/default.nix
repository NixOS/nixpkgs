{ stdenv, fetchgit, ocaml, findlib, ncurses }:

stdenv.mkDerivation rec {
  version = "2.1.1";
  name = "ocaml-camlpdf-${version}";
  src = fetchgit {
    url = https://github.com/johnwhitington/camlpdf.git;
    rev = "refs/tags/v${version}";
    sha256 = "118656hc3zv5nwmbhr6llvb7q2pbxk2hz95bv8x4879a9qsnb4xr";
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
