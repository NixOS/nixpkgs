{
  lib,
  buildDunePackage,
  fetchurl,
  ounit2,
  lwt,
  cstruct,
  io-page,
  mirage-flow,
  xenstore,
  xenstore_transport,
}:

buildDunePackage rec {
  pname = "vchan";
  version = "6.0.2";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-vchan/releases/download/v${version}/vchan-${version}.tbz";
    hash = "sha256-fki12lrWuIweGX/vSD2gbMX9qaM4KthiDZLeJYWcX+U=";
  };

  propagatedBuildInputs = [
    lwt
    cstruct
    io-page
    mirage-flow
    xenstore
    xenstore_transport
  ];

  doCheck = true;
  checkInputs = [
    ounit2
  ];

  meta = with lib; {
    description = "Xen Vchan implementation";
    homepage = "https://github.com/mirage/ocaml-vchan";
    license = licenses.isc;
    maintainers = teams.xen.members ++ [ maintainers.sternenseemann ];
  };
}
