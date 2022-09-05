{ lib, buildDunePackage, dune_3 }:

buildDunePackage rec {
  pname = "xdg";
  inherit (dune_3) src version;

  duneVersion = "3";

  dontAddPrefix = true;

  meta = with lib; {
    description = "XDG Base Directory Specification";
    inherit (dune_3.meta) homepage;
    maintainers = with lib.maintainers; [ ];
    license = licenses.mit;
  };
}
