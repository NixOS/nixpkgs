{
  buildDunePackage,
  faraday,
  faraday-lwt,
  lwt,
}:

buildDunePackage {
  pname = "faraday-lwt-unix";
  inherit (faraday) version src;
  duneVersion = "3";

  propagatedBuildInputs = [
    lwt
    faraday-lwt
  ];

  meta = faraday.meta // {
    description = "Lwt + Unix support for Faraday";
  };
}
