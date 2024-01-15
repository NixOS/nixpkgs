{ lib, buildDunePackage
, macaddr, cstruct
}:

buildDunePackage {
  pname = "macaddr-cstruct";

  inherit (macaddr) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ macaddr cstruct ];

  doCheck = true;

  meta = macaddr.meta // {
    description = "A library for manipulation of MAC address representations using Cstructs";
  };
}
