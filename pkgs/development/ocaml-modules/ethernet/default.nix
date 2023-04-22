{ lib
, buildDunePackage
, fetchurl
, cstruct
, logs
, lwt
, macaddr
, mirage-net
, mirage-profile
, ppx_cstruct
}:

buildDunePackage rec {
  pname = "ethernet";
  version = "3.0.0";

  minimalOCamlVersion = "4.08";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    hash = "sha256:0a898vp9dw42majsvzzvs8pc6x4ns01wlwhwbacixliv6vv78ng9";
  };

  buildInputs = [
    ppx_cstruct
  ];

  propagatedBuildInputs = [
    cstruct
    mirage-net
    macaddr
    mirage-profile
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
