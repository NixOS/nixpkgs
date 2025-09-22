{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  astring,
  fmt,
  fpath,
  logs,
  rresult,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-bos";
  version = "0.2.1";

  src = fetchurl {
    url = "https://erratique.ch/software/bos/releases/bos-${version}.tbz";
    sha256 = "sha256-2NYueGsQ1pfgRXIFqO7eqifrzJDxhV8Y3xkMrC49jzc=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [ topkg ];
  propagatedBuildInputs = [
    astring
    fmt
    fpath
    logs
    rresult
  ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "Basic OS interaction for OCaml";
    homepage = "https://erratique.ch/software/bos";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
