{ lib, buildDunePackage
, ipaddr, cstruct
}:

buildDunePackage rec {
  pname = "ipaddr-cstruct";

  inherit (ipaddr) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ ipaddr cstruct ];

  doCheck = true;

  meta = ipaddr.meta // {
    description = "A library for manipulation of IP address representations using Cstructs";
  };
}
