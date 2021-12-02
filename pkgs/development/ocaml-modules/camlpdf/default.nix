{ lib, stdenv, fetchFromGitHub, which, ocaml, findlib }:

if !lib.versionAtLeast ocaml.version "4.02"
then throw "camlpdf is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "2.4";
  name = "ocaml${ocaml.version}-camlpdf-${version}";
  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "camlpdf";
    rev = "v${version}";
    sha256 = "09kzrgmlxb567315p3fy59ba0kv7xhp548n9i3l4wf9n06p0ww9m";
  };

  buildInputs = [ which ocaml findlib ];

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';

  meta = with lib; {
    description = "An OCaml library for reading, writing and modifying PDF files";
    homepage = "https://github.com/johnwhitington/camlpdf";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [vbgl];
  };
}
