{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  camlpdf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml${ocaml.version}-cpdf";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "johnwhitington";
    repo = "cpdf-source";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MK48ajZmpXibbaJ4x2vaHhh2N+OBRqj7zT8eaVenxDY=";
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

  meta = {
    description = "PDF Command Line Tools";
    homepage = "https://www.coherentpdf.com/";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "cpdf";
    inherit (ocaml.meta) platforms;
    broken = lib.versionOlder ocaml.version "4.10";
  };
})
