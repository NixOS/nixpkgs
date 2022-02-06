{ lib, stdenv, fetchFromGitHub, ocaml, findlib, camlpdf, ncurses }:

if !lib.versionAtLeast ocaml.version "4.10"
then throw "cpdf is not available for OCaml ${ocaml.version}"
else

let version = "2.5"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-cpdf-${version}";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "cpdf-source";
    rev = "v${version}";
    sha256 = "sha256:1qmx229nij7g6qmiacmyy4mcgx3k9509p4slahivshqm79d6wiwl";
  };

  buildInputs = [ ocaml findlib ncurses ];
  propagatedBuildInputs = [ camlpdf ];

  preInstall = ''
    mkdir -p $OCAMLFIND_DESTDIR
    mkdir -p $out/bin
    cp cpdf $out/bin
    mkdir -p $out/share/
    cp -r doc $out/share
    cp cpdfmanual.pdf $out/share/doc/cpdf/
  '';

  meta = with lib; {
    homepage = "https://www.coherentpdf.com/";
    platforms = ocaml.meta.platforms or [];
    description = "PDF Command Line Tools";
    license = licenses.unfree;
    maintainers = [ maintainers.vbgl ];
  };
}
