{ lib, buildDunePackage, dune_3 }:

buildDunePackage rec {
  pname = "xdg";
  inherit (dune_3) src version;

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  dontAddPrefix = true;

  meta = with lib; {
    description = "XDG Base Directory Specification";
    inherit (dune_3.meta) homepage;
    maintainers = [ ];
    license = licenses.mit;
  };
}
