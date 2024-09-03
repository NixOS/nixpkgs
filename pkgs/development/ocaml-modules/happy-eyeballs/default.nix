{ lib, buildDunePackage, fetchurl
, domain-name, duration, fmt, ipaddr, logs
}:

buildDunePackage rec {
  pname = "happy-eyeballs";
  version = "1.1.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/roburio/happy-eyeballs/releases/download/v${version}/happy-eyeballs-${version}.tbz";
    hash = "sha256-zmZwueHs9be8M5x8Zm2rjPJb6bryDNTAeE8SEFtP3ME=";
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
