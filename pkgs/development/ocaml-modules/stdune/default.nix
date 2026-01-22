{
  buildDunePackage,
  dune,
  dyn,
  ordering,
  csexp,
}:

buildDunePackage {
  pname = "stdune";
  inherit (dune) version src;

  dontAddPrefix = true;

  propagatedBuildInputs = [
    dyn
    ordering
    csexp
  ];

  preBuild = ''
    rm -r vendor/csexp
  '';

  meta = dune.meta // {
    description = "Dune's unstable standard library";
  };
}
