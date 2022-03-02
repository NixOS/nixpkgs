{ lib, stdenv, fetchFromGitLab, ocaml, findlib, bzip2, autoreconfHook }:

if !lib.versionAtLeast ocaml.version "4.02"
then throw "bz2 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-bz2";
  version = "0.7.0";

  src = fetchFromGitLab {
    owner = "irill";
    repo = "camlbz2";
    rev = version;
    sha256 = "sha256-jBFEkLN2fbC3LxTu7C0iuhvNg64duuckBHWZoBxrV/U=";
  };

  autoreconfFlags = "-I .";

  nativeBuildInputs = [
    autoreconfHook
    ocaml
    findlib
  ];

  propagatedBuildInputs = [
    bzip2
  ];

  strictDeps = true;

  preInstall = "mkdir -p $OCAMLFIND_DESTDIR/stublibs";

  meta = with lib; {
    description = "OCaml bindings for the libbz2 (AKA, bzip2) (de)compression library";
    downloadPage = "https://gitlab.com/irill/camlbz2";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
  };
}
