{ lib, buildDunePackage, dune_2, dune-glob, dune-private-libs }:

buildDunePackage rec {
  pname = "dune-action-plugin";
  inherit (dune_2) src version patches;

  useDune2 = true;

  dontAddPrefix = true;

  propagatedBuildInputs = [ dune-glob dune-private-libs ];

  meta = with lib; {
    inherit (dune_2.meta) homepage;
    description = "API for writing dynamic Dune actions";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
