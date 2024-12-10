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
  version = "3.1.1";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/shared-memory-ring/releases/download/v${version}/shared-memory-ring-${version}.tbz";
    hash = "sha256-KW8grij/OAnFkdUdRRZF21X39DvqayzkTWeRKwF8uoU=";
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
