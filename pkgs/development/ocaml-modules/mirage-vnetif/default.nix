{ lib, buildDunePackage, fetchurl
, lwt, mirage-net
, cstruct, ipaddr, macaddr
, duration, logs
}:

buildDunePackage rec {
  pname = "mirage-vnetif";
  version = "0.6.2";

  minimalOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-SorcrPRhhCYhHasLQGHvTtLo229/3xVB6f7/XOlFRSI=";
  };

  propagatedBuildInputs = [
    lwt
    mirage-net
    cstruct
    ipaddr
    macaddr
    duration
    logs
  ];

  meta = with lib; {
    description = "Virtual network interface and software switch for Mirage";
    homepage = "https://github.com/mirage/${pname}";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
