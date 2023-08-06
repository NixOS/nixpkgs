{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg, mtime }:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.08")
  "mtime is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-mtime";
  version = "1.4.0";

  src = fetchurl {
    url = "https://erratique.ch/software/mtime/releases/mtime-${version}.tbz";
    sha256 = "VQyYEk8+57Yq8SUuYossaQUHZKqemHDJtf4LK8qjxvc=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;
  inherit (mtime) meta;
}
