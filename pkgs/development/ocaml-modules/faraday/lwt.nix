{ buildDunePackage, faraday, lwt }:

buildDunePackage rec {
  pname = "faraday-lwt";
  inherit (faraday) version src minimumOCamlVersion;

  propagatedBuildInputs = [ faraday lwt ];

  meta = faraday.meta // {
    description = "Lwt support for Faraday";
  };
}
