{ buildDunePackage, faraday, lwt }:

buildDunePackage rec {
  pname = "faraday-lwt";
  inherit (faraday) version src useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [ faraday lwt ];

  meta = faraday.meta // {
    description = "Lwt support for Faraday";
  };
}
