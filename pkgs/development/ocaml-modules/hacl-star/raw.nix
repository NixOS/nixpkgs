{ lib, which, stdenv, fetchzip, ocaml, findlib, hacl-star, ctypes, cppo }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-hacl-star-raw";
  version = "0.4.5";

  src = fetchzip {
    url = "https://github.com/project-everest/hacl-star/releases/download/ocaml-v${version}/hacl-star.${version}.tar.gz";
    sha256 = "1330vgbf5krlkvifby96kyk13xhmihajk2w5hgf2761jrljmnnrs";
    stripRoot = false;
  };

  sourceRoot = "./source/raw";

  minimalOCamlVersion = "4.08";

  # strictoverflow is disabled because it breaks aarch64-darwin
  hardeningDisable = [ "strictoverflow" ];

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

  nativeBuildInputs = [
    which
    ocaml
    findlib
  ];

  propagatedBuildInputs = [
    ctypes
  ];

  nativeCheckInputs = [
    cppo
  ];

  strictDeps = true;

  doCheck = true;

  meta = {
    description = "Auto-generated low-level OCaml bindings for EverCrypt/HACL*";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ulrikstrid ];
    platforms = ocaml.meta.platforms;
  };
}
