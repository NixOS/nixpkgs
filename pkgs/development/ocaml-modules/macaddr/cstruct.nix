{ lib, buildDunePackage
, macaddr, cstruct
}:

buildDunePackage {
  pname = "macaddr-cstruct";

  inherit (macaddr) version src minimumOCamlVersion;

  useDune2 = true;

  propagatedBuildInputs = [ macaddr cstruct ];

  doCheck = true;

  meta = macaddr.meta // {
    description = "A library for manipulation of MAC address representations using Cstructs";
  };
}
