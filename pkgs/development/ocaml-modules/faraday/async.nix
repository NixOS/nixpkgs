{ buildDunePackage, faraday, core, async }:

buildDunePackage rec {
  pname = "faraday-async";
  inherit (faraday) version src useDune2;

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ faraday core async ];

  meta = faraday.meta // {
    description = "Async support for Faraday";
  };
}
