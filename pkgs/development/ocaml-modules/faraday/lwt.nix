{
  buildDunePackage,
  faraday,
  lwt,
}:

buildDunePackage rec {
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
