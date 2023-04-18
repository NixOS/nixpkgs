{ lib, buildDunePackage
, ounit2
, ... ## 0install
}@inputs:

buildDunePackage {
  pname = "0install-solver";
  inherit (inputs."0install") version src;

  duneVersion = "3";

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = inputs."0install".meta // {
    description = "Package dependency solver";
  };
}
