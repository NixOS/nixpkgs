{
  buildDunePackage,
  mirage-time,
  lwt,
  duration,
}:

buildDunePackage {
  pname = "mirage-time-unix";

  inherit (mirage-time) src version;
  duneVersion = "3";

  propagatedBuildInputs = [
    mirage-time
    lwt
    duration
  ];

  meta = mirage-time.meta // {
    description = "Time operations for MirageOS on Unix";
  };
}
