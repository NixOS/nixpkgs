{
  lib,
  buildDunePackage,
  dune_3,
  dyn,
  ordering,
  csexp,
}:

buildDunePackage {
  pname = "stdune";
  inherit (dune_3) version src;
  duneVersion = "3";

  dontAddPrefix = true;

  propagatedBuildInputs = [
    dyn
    ordering
    csexp
  ];

  preBuild = ''
    rm -r vendor/csexp
  '';

  meta = dune_3.meta // {
    description = "Dune's unstable standard library";
  };
}
