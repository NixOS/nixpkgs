{ buildDunePackage, faraday, faraday-lwt, lwt }:

buildDunePackage rec {
  pname = "faraday-lwt-unix";
  inherit (faraday) version src useDune2 minimumOCamlVersion;

  propagatedBuildInputs = [ lwt faraday-lwt ];

  meta = faraday.meta // {
    description = "Lwt + Unix support for Faraday";
  };
}
