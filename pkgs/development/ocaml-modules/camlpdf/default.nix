{ lib, stdenv, fetchFromGitHub, which, ocaml, findlib }:

if lib.versionOlder ocaml.version "4.10"
then throw "camlpdf is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "2.7";
  pname = "ocaml${ocaml.version}-camlpdf";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "camlpdf";
    rev = "v${version}";
    hash = "sha256-SVmLWffB7GF+Bu0tj5fIvQVMRh6uV3u2G3rC4cVH2Gw=";
  };

  nativeBuildInputs = [ which ocaml findlib ];

  strictDeps = true;

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';

  meta = with lib; {
    description = "OCaml library for reading, writing and modifying PDF files";
    homepage = "https://github.com/johnwhitington/camlpdf";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [vbgl];
  };
}
