{ stdenv, fetchgit, ocaml, findlib, camlpdf, ncurses }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.0";

let version = "2.1.1"; in

stdenv.mkDerivation {
  name = "ocaml-cpdf-${version}";

  src = fetchgit {
    url = https://github.com/johnwhitington/cpdf-source.git;
    rev = "refs/tags/v${version}";
    sha256 = "01dq7z3admwnyp22z1h43a8f3glii3zxc9c7i6s2rgza3pd9jq4k";
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

  meta = {
    homepage = http://www.coherentpdf.com/;
    platforms = ocaml.meta.platforms or [];
    description = "PDF Command Line Tools";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
