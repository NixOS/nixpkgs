{ buildDunePackage, irmin, fmt, ptime, mirage-clock }:

buildDunePackage {
  pname = "irmin-mirage";

  inherit (irmin) version src;

  propagatedBuildInputs = [
    irmin fmt ptime mirage-clock
  ];

  meta = irmin.meta // {
    description = "MirageOS-compatible Irmin stores";
  };
}
