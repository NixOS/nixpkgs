{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
}:

stdenv.mkDerivation rec {
  version = "2.8";
  pname = "ocaml${ocaml.version}-camlpdf";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "camlpdf";
    rev = "v${version}";
    hash = "sha256-+SFuFqlrP0nwm199y0QFWYvlwD+Cbh0PHA5bmXIWdNk=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];

  strictDeps = true;

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';

<<<<<<< HEAD
  meta = {
    description = "OCaml library for reading, writing and modifying PDF files";
    homepage = "https://github.com/johnwhitington/camlpdf";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ vbgl ];
=======
  meta = with lib; {
    description = "OCaml library for reading, writing and modifying PDF files";
    homepage = "https://github.com/johnwhitington/camlpdf";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ vbgl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = lib.versionOlder ocaml.version "4.10";
  };
}
