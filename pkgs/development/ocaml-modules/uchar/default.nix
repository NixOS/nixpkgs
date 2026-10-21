{
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  opaline,
  withShared ? true,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-uchar";
  version = "0.0.2";

  src = fetchurl {
    url = "https://github.com/ocaml/uchar/releases/download/v${version}/uchar-${version}.tbz";
    hash = "sha256-Rzl/MWy+diNK9Tx0oflFIVS6O9tU/O1cqslZ9Q9XWvA=";
  };

  nativeBuildInputs = [
    ocaml
    ocamlbuild
    findlib
  ];

  strictDeps = true;

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=${lib.boolToString withShared}";
  installPhase = "${opaline}/bin/opaline -libdir $OCAMLFIND_DESTDIR";
  configurePlatforms = [ ];

  meta = {
    description = "Compatibility library for OCaml’s Uchar module";
    inherit (ocaml.meta) platforms license;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
