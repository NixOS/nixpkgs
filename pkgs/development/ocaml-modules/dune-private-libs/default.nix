{
  lib,
  buildDunePackage,
  dune,
  stdune,
}:

buildDunePackage {
  pname = "dune-private-libs";

  inherit (dune) src version;

  dontAddPrefix = true;

  propagatedBuildInputs = [ stdune ];

  meta = {
    description = "Private libraries of Dune";
    maintainers = [ ];
    license = lib.licenses.mit;
  };
}
