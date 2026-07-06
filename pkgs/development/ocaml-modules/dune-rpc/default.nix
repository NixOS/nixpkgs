{
  lib,
  buildDunePackage,
  dune,
  csexp,
  stdune,
  ocamlc-loc,
  ordering,
  pp,
  xdg,
  dyn,
}:

buildDunePackage {
  pname = "dune-rpc";
  inherit (dune) src version;

  dontAddPrefix = true;

  propagatedBuildInputs = [
    csexp
    stdune
    ocamlc-loc
    ordering
    pp
    xdg
    dyn
  ];

  meta = {
    description = "Library to connect and control a running dune instance";
    inherit (dune.meta) homepage;
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
