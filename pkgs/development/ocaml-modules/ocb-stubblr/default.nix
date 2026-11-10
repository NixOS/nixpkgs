{
  stdenv,
  lib,
  fetchzip,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  astring,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocb-stubblr";
  version = "0.1.1";

  src = fetchzip {
    url = "https://github.com/pqwy/ocb-stubblr/releases/download/v${version}/ocb-stubblr-${version}.tbz";
    name = "src.tar.bz";
    hash = "sha256-Zd9a2EFT5j944xCFmWD4Td21VB7uGHZoNE4yvgfI9y0=";
  };

  patches = [ ./pkg-config.patch ];

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [
    topkg
    ocamlbuild
  ];

  propagatedBuildInputs = [ astring ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "OCamlbuild plugin for C stubs";
    homepage = "https://github.com/pqwy/ocb-stubblr";
    license = lib.licenses.isc;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
