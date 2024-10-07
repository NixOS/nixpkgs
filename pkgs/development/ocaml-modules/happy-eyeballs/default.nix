{ lib, buildDunePackage, fetchurl
, domain-name, duration, fmt, ipaddr, logs
}:

buildDunePackage rec {
  pname = "happy-eyeballs";
  version = "1.2.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/roburio/happy-eyeballs/releases/download/v${version}/happy-eyeballs-${version}.tbz";
    hash = "sha256-3400G65qNF7Q+9rY1e/AbPJ7thp25A/rep9D7Jhn+0Q=";
  };

  propagatedBuildInputs = [
    domain-name
    duration
    fmt
    ipaddr
    logs
  ];

  meta = {
    description = "Connecting to a remote host via IP version 4 or 6";
    homepage = "https://github.com/roburio/happy-eyeballs";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl ulrikstrid ];
  };
}
