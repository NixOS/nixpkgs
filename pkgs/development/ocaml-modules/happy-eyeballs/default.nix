{ lib, buildDunePackage, fetchurl
, domain-name, duration, fmt, ipaddr, logs
}:

buildDunePackage rec {
  pname = "happy-eyeballs";
  version = "0.1.3";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/roburio/happy-eyeballs/releases/download/v${version}/happy-eyeballs-${version}.tbz";
    sha256 = "sha256:0ns1bxcmx0rkq4am6vl2aargdzkfhria8sfmgnh8dgzvvj93cc1c";
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
    maintainers = [ lib.maintainers.vbgl ];
  };
}
