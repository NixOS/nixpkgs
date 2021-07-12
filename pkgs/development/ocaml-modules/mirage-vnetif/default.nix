{ lib, buildDunePackage, fetchurl
, lwt, mirage-time, mirage-clock, mirage-net
, cstruct, ipaddr, macaddr, mirage-profile
, duration, logs
}:

buildDunePackage rec {
  pname = "mirage-vnetif";
  version = "0.5.0";

  minimumOCamlVersion = "4.06";

  # due to cstruct
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0cpqwf51v2cpz41dfqxabf3bsabwyl6a0h0v2ncrn33q58i60m5q";
  };

  propagatedBuildInputs = [
    lwt
    mirage-net
    mirage-time
    mirage-clock
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
