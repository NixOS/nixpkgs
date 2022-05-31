{ lib, fetchurl, buildDunePackage
, duration, domain-name, ipaddr, fmt, logs
}:

buildDunePackage rec {
  pname = "happy-eyeballs";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/roburio/happy-eyeballs/releases/download/v${version}/happy-eyeballs-${version}.tbz";
    sha256 = "17mnid1gvq1ml1zmqzn0m6jmrqw4kqdrjqrdsrphl5kxxyhs03m6";
  };
  minimumOCamlVersion = "4.08";

  strictDeps = true;

  buildInputs = [
    duration domain-name ipaddr fmt logs
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/roburio/happy-eyeballs";
    description = "Connecting to a remote host via IP version 4 or 6";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ulrikstrid ];
  };
}

