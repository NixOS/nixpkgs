{ lib, which, stdenv, fetchzip, ocaml, findlib, hacl-star, ctypes, cppo }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-hacl-star-raw";
  version = "0.3.2";

  src = fetchzip {
    url = "https://github.com/project-everest/hacl-star/releases/download/ocaml-v${version}/hacl-star.${version}.tar.gz";
    sha256 = "1wp27vf0g43ggs7cv85hpa62jjvzkwzzg5rfznbwac6j6yr17zc7";
    stripRoot = false;
  };

  sourceRoot = "./source/raw";

  minimalOCamlVersion = "4.05";

  postPatch = ''
    patchShebangs ./
  '';

  preInstall = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
  '';

  installTargets = "install-hacl-star-raw";

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  buildInputs = [
    which
    ocaml
    findlib
  ];

  propagatedBuildInputs = [
    ctypes
  ];

  checkInputs = [
    cppo
  ];

  doCheck = true;

  meta = {
    description = "Auto-generated low-level OCaml bindings for EverCrypt/HACL*";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ulrikstrid ];
    platforms = ocaml.meta.platforms;
  };
}
