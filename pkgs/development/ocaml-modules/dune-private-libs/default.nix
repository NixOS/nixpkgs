{ lib, buildDunePackage, dune_2 }:

buildDunePackage rec {
  pname = "dune-private-libs";

  inherit (dune_2) src version;

  dontAddPrefix = true;

  meta = with lib; {
    description = "Private libraries of Dune";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
