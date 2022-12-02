{ buildDunePackage, lib, faraday, core_unix, async }:

buildDunePackage rec {
  pname = "faraday-async";
  inherit (faraday) version src;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ faraday core_unix async ];

  meta = faraday.meta // {
    description = "Async support for Faraday";
  };
}
