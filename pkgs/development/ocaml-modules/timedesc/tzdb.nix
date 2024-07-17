{
  lib,
  buildDunePackage,
  timedesc,
}:

buildDunePackage {
  pname = "timedesc-tzdb";

  inherit (timedesc) version src sourceRoot;

  meta = timedesc.meta // {
    description = "Virtual library for Timedesc time zone database backends";
  };
}
