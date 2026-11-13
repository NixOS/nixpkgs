{
  lib,
  buildDunePackage,
  fetchzip,

  flint-c,
  zarith,
  ctypes,
  dune-configurator,
}:

buildDunePackage (finalAttrs: {
  pname = "flint";
  version = "0.4.2";

  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/bobot/ocaml-flint/releases/download/0.4.2/flint-0.4.2.tbz";
    hash = "sha256-dZiznSROdHrQdqgxu8wXtBiQE0gCnHQjbQ+QDzCdygo=";
  };

  dontConfigure = true; # ./configure directory

  propagatedBuildInputs = [
    flint-c
    zarith
    ctypes
    dune-configurator
  ];

  meta = {
    description = "OCaml stubs for Flint2, Arb, Antic, Calcium";
    homepage = "https://github.com/bobot/ocaml-flint";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ luc65r ];
  };
})
