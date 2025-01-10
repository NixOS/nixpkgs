{
  buildDunePackage,
  faraday,
  core_unix ? null,
  async,
}:

buildDunePackage rec {
  pname = "faraday-async";
  inherit (faraday) version src;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [
    faraday
    core_unix
    async
  ];

  meta = faraday.meta // {
    description = "Async support for Faraday";
  };
}
