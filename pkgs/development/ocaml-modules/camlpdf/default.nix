{ stdenv, fetchFromGitHub, ocaml, findlib }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "camlpdf is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "2.3";
  name = "ocaml${ocaml.version}-camlpdf-${version}";
  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "camlpdf";
    rev = "v${version}";
    sha256 = "1z8h6bjzmlscr6h6kdvzj8kspifb4n9dg7zi54z1cv2qi03kr8dk";
  };

  buildInputs = [ ocaml findlib ];

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
    homepage = "https://github.com/johnwhitington/camlpdf";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [vbgl];
  };
}
