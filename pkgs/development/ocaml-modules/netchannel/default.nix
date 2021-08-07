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
, rresult
}:

buildDunePackage rec {
  pname = "netchannel";
  version = "2.0.0";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-net-xen/releases/download/v${version}/mirage-net-xen-v${version}.tbz";
    sha256 = "ec3906ef1804ef6a9e36b91f4ae73ce4849e9e0d1d36a80fe66b5f905fab93ad";
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
    rresult
  ];

  meta = with lib; {
    description = "Network device for reading and writing Ethernet frames via then Xen netfront/netback protocol";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/mirage-net-xen";
  };
}
