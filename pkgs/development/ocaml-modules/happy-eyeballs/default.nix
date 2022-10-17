{ lib, buildDunePackage, fetchurl
, domain-name, duration, fmt, ipaddr, logs
}:

buildDunePackage rec {
  pname = "happy-eyeballs";
  version = "0.3.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/roburio/happy-eyeballs/releases/download/v${version}/happy-eyeballs-${version}.tbz";
    sha256 = "17mnid1gvq1ml1zmqzn0m6jmrqw4kqdrjqrdsrphl5kxxyhs03m6";
  };

  strictDeps = true;

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
