{
  buildDunePackage,
  faraday,
  lwt,
}:

buildDunePackage {
  pname = "faraday-lwt";
  inherit (faraday) version src;

  propagatedBuildInputs = [
    faraday
    lwt
  ];
  duneVersion = "3";

  meta = faraday.meta // {
    description = "Lwt support for Faraday";
  };
}
