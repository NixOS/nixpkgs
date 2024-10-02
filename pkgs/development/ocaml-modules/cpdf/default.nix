{ lib, stdenv, fetchFromGitHub, ocaml, findlib, camlpdf, ncurses }:

if lib.versionOlder ocaml.version "4.10"
then throw "cpdf is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-cpdf";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "cpdf-source";
    rev = "v${version}";
    hash = "sha256-lFI7f1t70Pw0LJjDrhaB7yQKR1N5906xNYB+fnrz55M=";
  };

  nativeBuildInputs = [ ocaml findlib ];
  buildInputs = [ ncurses ];
  propagatedBuildInputs = [ camlpdf ];

  strictDeps = true;

  preInstall = ''
    mkdir -p $OCAMLFIND_DESTDIR
    mkdir -p $out/bin
    cp cpdf $out/bin
    mkdir -p $out/share/
    cp -r doc $out/share
    cp cpdfmanual.pdf $out/share/doc/cpdf/
  '';

  meta = with lib; {
    description = "PDF Command Line Tools";
    homepage = "https://www.coherentpdf.com/";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "cpdf";
    inherit (ocaml.meta) platforms;
  };
}
