{ lib, buildDunePackage, fetchurl
, ipaddr, cstruct, lwt, rresult, logs, lru
, tcpip, ethernet, stdlib-shims
, alcotest, mirage-clock-unix
, ppxlib, ppx_deriving
}:

buildDunePackage rec {
  pname = "mirage-nat";
  version = "2.2.3";

  minimumOCamlVersion = "4.06";

  # due to cstruct
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0cy95j184hi8fm1h6z6x1brjfrmbq3zjy2mqz99m8ys9vwkb63ma";
  };

  buildInputs = [
    ppxlib
  ];

  propagatedBuildInputs = [
    ipaddr
    cstruct
    lwt
    rresult
    logs
    lru
    tcpip
    ethernet
    stdlib-shims
    ppx_deriving
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-clock-unix
  ];

  meta = with lib; {
    description = "Mirage-nat is a library for network address translation to be used with MirageOS";
    homepage = "https://github.com/mirage/${pname}";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
