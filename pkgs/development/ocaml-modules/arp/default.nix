{ lib, buildDunePackage, fetchurl
, cstruct, ipaddr, macaddr, logs, lwt, duration
, mirage-time, mirage-protocols, mirage-profile
, alcotest, ethernet, fmt, mirage-vnetif, mirage-random
, mirage-random-test, mirage-clock-unix, mirage-time-unix
, bisect_ppx
}:

buildDunePackage rec {
  pname = "arp";
  version = "2.3.1";

  minimumOCamlVersion = "4.06";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "1nzm3fbkvz702g8f60fs49736lpffwchy64i1l1raxm9b4lmdk3p";
  };

  nativeBuildInputs = [
    bisect_ppx
  ];

  propagatedBuildInputs = [
    cstruct
    ipaddr
    macaddr
    logs
    mirage-time
    mirage-protocols
    lwt
    duration
    mirage-profile
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-profile
    mirage-random
    mirage-random-test
    mirage-vnetif
    mirage-clock-unix
    mirage-random
    mirage-time-unix
    ethernet
  ];

  meta = with lib; {
    description = "Address Resolution Protocol purely in OCaml";
    license = licenses.isc;
    homepage = "https://github.com/mirage/arp";
    maintainers = [ maintainers.sternenseemann ];
  };
}
