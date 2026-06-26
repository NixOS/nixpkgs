{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.9.1";
  pname = "ocaml${ocaml.version}-camlpdf";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "camlpdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f3Bm64T27eiIzOY2nwdzMRH68VlyNp2jXpOPyBouSCs=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];

  strictDeps = true;

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OCaml library for reading, writing and modifying PDF files";
    homepage = "https://github.com/johnwhitington/camlpdf";
    changelog = "https://github.com/johnwhitington/camlpdf/blob/${finalAttrs.src.rev}/Changes.txt";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ vbgl ];
    teams = with lib.teams; [ ngi ];
    broken = lib.versionOlder ocaml.version "4.10";
  };
})
