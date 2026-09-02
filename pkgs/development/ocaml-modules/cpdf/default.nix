{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  camlpdf,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml${ocaml.version}-cpdf";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "cpdf-source";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P3CQwYp23URVBDcdnrRAg7gAsOMIifwraIcFSJh8pd0=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "PDF Command Line Tools";
    homepage = "https://www.coherentpdf.com/";
    changelog = "https://github.com/johnwhitington/cpdf-source/blob/${finalAttrs.src.rev}/Changes.txt";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ vbgl ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "cpdf";
    inherit (ocaml.meta) platforms;
    broken = lib.versionOlder ocaml.version "4.10";
  };
})
