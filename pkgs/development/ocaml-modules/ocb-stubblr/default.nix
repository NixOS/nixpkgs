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
  version = "0.1.0";

  src = fetchzip {
    url = "https://github.com/pqwy/ocb-stubblr/releases/download/v${version}/ocb-stubblr-${version}.tbz";
    name = "src.tar.bz";
    sha256 = "0hpds1lkq4j8wgslv7hnirgfrjmqi36h5rarpw9mwf24gfp5ays2";
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
