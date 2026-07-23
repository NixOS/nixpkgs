{
  buildDunePackage,
  dune,
  dyn,
  ordering,
  pp,
  csexp,
  fs-io,
  top-closure,
}:

buildDunePackage {
  pname = "stdune";
  inherit (dune) version src;

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
