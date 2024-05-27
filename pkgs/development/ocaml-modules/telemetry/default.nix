{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "telemetry";
  version = "0.0.1";

  minimalOCamlVersion = "4.12";

  src = fetchurl {
    url = "https://github.com/leostera/telemetry/releases/download/${version}/telemetry-${version}.tbz";
    hash = "sha256-YEf7zC/F2zJBtQNfyJ2OznKmoFo1Ms9O2WgiOFkhp28=";
  };

  doCheck = true;

  meta = {
    description = "A lightweight library for dispatching and handling events, with a focus on metrics and instrumentation";
    homepage = "https://github.com/leostera/telemetry";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
