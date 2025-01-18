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

  meta = with lib; {
    description = "Caches (bounded-size stores) for Lwt promises";
    license = licenses.mit;
    maintainers = [ maintainers.ulrikstrid ];
  };
}
