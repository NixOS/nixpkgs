{ lib, buildDunePackage, ringo, lwt }:

buildDunePackage {
  pname = "ringo-lwt";
  inherit (ringo) version src doCheck useDune2;

  propagatedBuildInputs = [
    ringo
    lwt
  ];

  meta = ringo.meta // {
    description = "Lwt-wrappers for Ringo caches";
  };
}
