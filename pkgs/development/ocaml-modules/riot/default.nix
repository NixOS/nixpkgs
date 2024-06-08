{ lib
, buildDunePackage
, fetchurl
, mirage-crypto-rng
, mtime
, gluon
, randomconv
, rio
, telemetry
, tls
}:

buildDunePackage rec {
  pname = "riot";
  version = "0.0.8";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/leostera/riot/releases/download/${version}/riot-${version}.tbz";
    hash = "sha256-SsiDz53b9bMIT9Q3IwDdB3WKy98WSd9fiieU41qZpeE=";
  };

  propagatedBuildInputs = [
    gluon
    mirage-crypto-rng
    mtime
    randomconv
    rio
    telemetry
    tls
  ];

  doCheck = false; # fails on sandbox

  meta = {
    description = "An actor-model multi-core scheduler for OCaml 5";
    homepage = "https://github.com/leostera/riot";
    changelog = "https://github.com/leostera/riot/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
