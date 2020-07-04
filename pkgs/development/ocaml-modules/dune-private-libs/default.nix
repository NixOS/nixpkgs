{ lib, buildDunePackage, dune_2 }:

buildDunePackage rec {
  pname = "dune-private-libs";

  useDune2 = true;

  inherit (dune_2) src version;

  minimumOCamlVersion = "4.07";

  dontAddPrefix = true;

  meta = with lib; {
    description = "Private libraries of Dune";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
