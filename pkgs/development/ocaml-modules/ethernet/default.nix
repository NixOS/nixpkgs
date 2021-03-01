{ lib, buildDunePackage, fetchurl
, rresult, cstruct, ppx_cstruct, mirage-net, mirage-protocols
, mirage-profile, macaddr, fmt, lwt, logs
}:

buildDunePackage rec {
  pname = "ethernet";
  version = "2.2.0";

  minimumOCamlVersion = "4.06";

  # necessary due to cstruct
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0qzisqibx2gd8rh330n642mk5wz229199rnlrs7x8cr5pnymif7z";
  };

  nativeBuildInputs = [
    ppx_cstruct
  ];

  propagatedBuildInputs = [
    rresult
    cstruct
    mirage-net
    mirage-protocols
    macaddr
    mirage-profile
    fmt
    lwt
    logs
  ];

  meta = with lib; {
    description = "OCaml Ethernet (IEEE 802.3) layer, used in MirageOS";
    homepage = "https://github.com/mirage/ethernet";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
