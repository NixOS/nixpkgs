{ buildDunePackage, faraday, lwt }:

buildDunePackage rec {
  pname = "faraday-lwt";
  inherit (faraday) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ faraday lwt ];

  meta = faraday.meta // {
    description = "Lwt support for Faraday";
  };
}
