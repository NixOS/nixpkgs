{
  buildDunePackage,
  dune,
  ordering,
  pp,
}:

buildDunePackage {
  pname = "dyn";
  inherit (dune) version src;

  dontAddPrefix = true;

  propagatedBuildInputs = [
    ordering
    pp
  ];

  meta = dune.meta // {
    description = "Dynamic type";
  };
}
