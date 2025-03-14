{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  camlpdf,
}:

if lib.versionOlder ocaml.version "4.10" then
  throw "cpdf is not available for OCaml ${ocaml.version}"
else

  stdenv.mkDerivation rec {
    pname = "ocaml${ocaml.version}-cpdf";
    version = "2.8";

    src = fetchFromGitHub {
      owner = "johnwhitington";
      repo = "cpdf-source";
      rev = "v${version}";
      hash = "sha256-DvTY5EQcvnL76RlQTcVqBiycqbCdGQCXzarSMH2P/pg=";
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

    meta = with lib; {
      description = "PDF Command Line Tools";
      homepage = "https://www.coherentpdf.com/";
      license = licenses.agpl3Only;
      maintainers = [ maintainers.vbgl ];
      mainProgram = "cpdf";
      inherit (ocaml.meta) platforms;
    };
  }
