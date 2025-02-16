{
  lib,
  which,
  stdenv,
  fetchzip,
  cmake,
  ocaml,
  findlib,
  ctypes,
  cppo,
}:
stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-hacl-star-raw";
  version = "0.7.2";

  src = fetchzip {
    url = "https://github.com/cryspen/hacl-packages/releases/download/ocaml-v${version}/hacl-star.${version}.tar.gz";
    hash = "sha256-6WPbdkT9IsX0Q8mF2vLBJMktEES8tU45JztOPepAL0o=";
    stripRoot = false;
  };

  patches = [
    ./aligned-alloc.patch
  ];

  # strictoverflow is disabled because it breaks aarch64-darwin
  hardeningDisable = [ "strictoverflow" ];

  postPatch = ''
    patchShebangs ./
  '';

  buildPhase = ''
    runHook preBuild

    make -C hacl-star-raw build-c
    make -C hacl-star-raw build-bindings

    runHook postBuild
  '';

  preInstall = ''
    mkdir $out
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
  '';

  installPhase = ''
    runHook preInstall

    make -C hacl-star-raw install

    runHook postInstall
  '';

  dontUseCmakeConfigure = true;
  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  createFindlibDestdir = true;

  nativeBuildInputs = [
    which
    cmake
    ocaml
    findlib
  ];

  propagatedBuildInputs = [
    ctypes
  ];

  checkInputs = [
    cppo
  ];

  strictDeps = true;

  doCheck = true;

  meta = {
    inherit (ocaml.meta) platforms;
    description = "Auto-generated low-level OCaml bindings for EverCrypt/HACL*";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
