{
  lib,
  buildDunePackage,
  ringo,
  aches,
  lwt,
}:

buildDunePackage {
  pname = "aches-lwt";
  inherit (ringo) src version;

  propagatedBuildInputs = [
    aches
    lwt
  ];

  meta = {
    description = "Caches (bounded-size stores) for Lwt promises";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
