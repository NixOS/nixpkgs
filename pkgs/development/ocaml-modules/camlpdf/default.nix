{stdenv, fetchgit, ocaml, findlib, ncurses}:

stdenv.mkDerivation {
  name = "ocaml-camlpdf-1.7.2";
  src = fetchgit {
    url = https://github.com/johnwhitington/camlpdf.git;
    rev = "73ee0c4cc71e4d5f2f046d0b41d301e0df1d78d9";
    sha256 = "0n3jpkwbh0qi282hvsvgz0hv9lwwd8rqy3pwgmpqr0rmbim8wss5";
  };

  buildInputs = [ ocaml findlib ncurses ];

  # Version number in META file is wrong
  patchPhase = ''
    patch -p 0 META <<EOF
    3c3
    < version="1.7.1"
    ---
    > version="1.7.2"
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
