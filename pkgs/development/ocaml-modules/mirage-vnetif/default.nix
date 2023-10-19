{ lib, buildDunePackage, fetchurl
, lwt, mirage-net
, cstruct, ipaddr, macaddr, mirage-profile
, duration, logs
}:

buildDunePackage rec {
  pname = "mirage-vnetif";
  version = "0.6.0";

  minimalOCamlVersion = "4.06";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-fzRoNFqdnj4Ke+eNdo5crvbnKDx6/+dQyu+K3rD5dYw=";
  };

  propagatedBuildInputs = [
    lwt
    mirage-net
    cstruct
    ipaddr
    macaddr
    mirage-profile
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
