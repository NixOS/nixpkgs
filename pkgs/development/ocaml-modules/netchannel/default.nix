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
  version = "2.1.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-net-xen/releases/download/v${version}/mirage-net-xen-${version}.tbz";
    sha256 = "sha256-kYsAf6ntwWKUp26dMcp5BScdUOaGpM46050jVZe6gfs=";
  };

  nativeBuildInputs = [
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
