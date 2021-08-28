{ lib, buildDunePackage, dune_2, dune-private-libs }:

buildDunePackage rec {
  pname = "dune-glob";
  inherit (dune_2) src version patches;

  useDune2 = true;

  dontAddPrefix = true;

  propagatedBuildInputs = [ dune-private-libs ];

  meta = with lib; {
    inherit (dune_2.meta) homepage;
    description = "Glob string matching language supported by dune";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
