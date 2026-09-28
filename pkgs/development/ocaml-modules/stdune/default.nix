{
  lib,
  buildDunePackage,
  ocaml,
  dune,
  dyn,
  ordering,
  pp,
  csexp,
  fs-io,
  top-closure,
  version ? if lib.versionAtLeast ocaml.version "4.13" then dune.version else "3.22.2",
}:

buildDunePackage {
  pname = "stdune";
  inherit version;

  inherit (dune.override { inherit version; }) src;

  dontAddPrefix = true;

  propagatedBuildInputs = [
    dyn
    ordering
    pp
    csexp
    fs-io
    top-closure
  ];

  meta = dune.meta // {
    description = "Dune's unstable standard library";
  };
}
