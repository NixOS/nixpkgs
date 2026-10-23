{
  buildDunePackage,
  ipaddr,
  cstruct,
}:

buildDunePackage {
  pname = "ipaddr-cstruct";

  inherit (ipaddr) version src;

  duneVersion = "3";

  propagatedBuildInputs = [
    ipaddr
    cstruct
  ];

  doCheck = true;

  meta = ipaddr.meta // {
    hasNoMaintainersButDependents = false;
    description = "Library for manipulation of IP address representations using Cstructs";
  };
}
