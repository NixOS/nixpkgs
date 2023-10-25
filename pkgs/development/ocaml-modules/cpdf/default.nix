{ lib, stdenv, fetchFromGitHub, ocaml, findlib, camlpdf, ncurses }:

if lib.versionOlder ocaml.version "4.10"
then throw "cpdf is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-cpdf";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "cpdf-source";
    rev = "v${version}";
    hash = "sha256-5gEv/lmca3FR16m4uxbCJ3y/XtTSBvoIojeKszc24ss=";
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
    license = licenses.unfree;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "cpdf";
    inherit (ocaml.meta) platforms;
  };
}
