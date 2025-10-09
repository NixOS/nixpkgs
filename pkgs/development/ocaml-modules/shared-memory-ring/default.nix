{
  lib,
  buildDunePackage,
  fetchurl,
  ppx_cstruct,
  cstruct,
  lwt,
  ounit,
}:

buildDunePackage rec {
  pname = "shared-memory-ring";
  version = "3.2.1";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/shared-memory-ring/releases/download/v${version}/shared-memory-ring-${version}.tbz";
    hash = "sha256-qSdntsPQo0/8JlbOoO6NAYtoa86HJy5yWHUsWi/PGDM=";
  };

  buildInputs = [
    ppx_cstruct
  ];

  propagatedBuildInputs = [
    cstruct
  ];

  doCheck = true;
  checkInputs = [
    lwt
    ounit
  ];

  meta = with lib; {
    description = "Shared memory rings for RPC and bytestream communications";
    license = licenses.isc;
    homepage = "https://github.com/mirage/shared-memory-ring";
    maintainers = [ maintainers.sternenseemann ];
  };
}
