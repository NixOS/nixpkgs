{ lib
, buildDunePackage
, fetchurl
, ppx_sexp_conv
, ppx_cstruct
, lwt
, mirage-net
, io-page
, mirage-xen
, ipaddr
, mirage-profile
, shared-memory-ring
, sexplib
, logs
, macaddr
, lwt-dllist
, result
}:

buildDunePackage rec {
  pname = "netchannel";
  version = "2.1.2";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-net-xen/releases/download/v${version}/mirage-net-xen-${version}.tbz";
    hash = "sha256-lTmwcNKiaq5EdJdM4UaaAVdZ+hTCX5U9MPKY/r3i7fw=";
  };

  buildInputs = [
    ppx_cstruct
  ];

  propagatedBuildInputs = [
    ppx_sexp_conv
    lwt
    mirage-net
    io-page
    mirage-xen
    ipaddr
    mirage-profile
    shared-memory-ring
    sexplib
    logs
    macaddr
    lwt-dllist
    result
  ];

  meta = with lib; {
    description = "Network device for reading and writing Ethernet frames via then Xen netfront/netback protocol";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/mirage-net-xen";
  };
}
