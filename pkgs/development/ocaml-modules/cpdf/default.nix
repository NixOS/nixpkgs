{ stdenv, fetchgit, ocaml, findlib, camlpdf, ncurses }:

let version = "2.2.1"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-cpdf-${version}";

  src = fetchgit {
    url = https://github.com/johnwhitington/cpdf-source.git;
    rev = "refs/tags/v${version}";
    sha256 = "1i2z417agnzzdavjfwb20r6716jl3sk5yi43ssy4jqzy6ah8x1ff";
  };

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

  meta = with stdenv.lib; {
    homepage = https://www.coherentpdf.com/;
    platforms = ocaml.meta.platforms or [];
    description = "PDF Command Line Tools";
    license = licenses.unfree;
    maintainers = [ maintainers.vbgl ];
  };
}
