{ lib, buildDunePackage, mirage
, mirage-block, mirage-channel, mirage-clock, mirage-console, mirage-device
, mirage-flow, mirage-fs, mirage-kv, mirage-net, mirage-protocols, mirage-random
, mirage-stack, mirage-time
}:

buildDunePackage {
  pname = "mirage-types";
  inherit (mirage) src version useDune2;

  propagatedBuildInputs = [ mirage-block mirage-channel mirage-clock
    mirage-console mirage-device mirage-flow mirage-fs mirage-kv mirage-net
    mirage-protocols mirage-random mirage-stack mirage-time
  ];

  meta = mirage.meta // {
    description = "Module type definitions for MirageOS applications";
  };
}
