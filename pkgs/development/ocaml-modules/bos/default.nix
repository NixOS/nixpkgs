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

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml${ocaml.version}-bos";
  version = if lib.versionAtLeast ocaml.version "4.14" then "0.3.0" else "0.2.1";

  src = fetchurl {
    url = "https://erratique.ch/software/bos/releases/bos-${finalAttrs.version}.tbz";
    hash =
      {
        "0.3.0" = "sha256-CJ82ntAJZ+kticxfzYSMVr2rXAJzfaTUg1UL9Wtaebw=";
        "0.2.1" = "sha256-2NYueGsQ1pfgRXIFqO7eqifrzJDxhV8Y3xkMrC49jzc=";
      }
      ."${finalAttrs.version}";
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
})
