{ lib, stdenv, fetchFromGitHub, ocaml, findlib, camlpdf, ncurses }:

let version = "2.3.1"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-cpdf-${version}";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "cpdf-source";
    rev = "v${version}";
    sha256 = "1gwz0iy28f67kbqap2q10nf98dalwbi03vv5j893z2an7pb4w68z";
  };

  prePatch = ''
    substituteInPlace META --replace 'version="1.7"' 'version="${version}"'
  '';

  buildInputs = [ ocaml findlib ncurses ];
  propagatedBuildInputs = [ camlpdf ];

  createFindlibDestdir = true;

  postInstall = ''
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
