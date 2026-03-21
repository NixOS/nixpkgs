{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.9";
  pname = "ocaml${ocaml.version}-camlpdf";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "camlpdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8xBna7GDFbFf48069/ct71uFxLJU0eBfKVRWDnyYocs=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];

  strictDeps = true;

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';

  meta = {
    description = "OCaml library for reading, writing and modifying PDF files";
    homepage = "https://github.com/johnwhitington/camlpdf";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ vbgl ];
    broken = lib.versionOlder ocaml.version "4.10";
  };
})
