{
  buildDunePackage,
  timedesc,
}:

buildDunePackage {
  pname = "timedesc-tzlocal";

  inherit (timedesc) version src sourceRoot;

  meta = timedesc.meta // {
    description = "Virtual library for Timedesc local time zone detection backends";
  };
}
