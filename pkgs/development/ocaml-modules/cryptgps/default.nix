{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
}:

stdenv.mkDerivation {
  pname = "ocaml-cryptgps";
  version = "0.2.1";

  src = fetchurl {
    url = "http://download.camlcity.org/download/cryptgps-0.2.1.tar.gz";
    hash = "sha256-emxlUxeB6YxkJ36Qi4gy9jIf4KjJKM1qfomnygSJ59Y=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];

  strictDeps = true;

  dontConfigure = true; # Skip configure phase

  createFindlibDestdir = true;

  meta = {
    homepage = "http://projects.camlcity.org/projects/cryptgps.html";
    description = "Cryptographic functions for OCaml";
    longDescription = ''
      This library implements the symmetric cryptographic algorithms
      Blowfish, DES, and 3DES. The algorithms are written in O'Caml,
      i.e. this is not a binding to some C library, but the implementation
      itself.
    '';
    license = lib.licenses.mit;
    broken = lib.versionAtLeast ocaml.version "4.06";
    inherit (ocaml.meta) platforms;
  };
}
