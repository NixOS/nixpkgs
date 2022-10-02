{ lib
, buildDunePackage
, fetchurl
, ppx_cstruct
, mirage-profile
, cstruct
, ounit
, stdlib-shims
}:

buildDunePackage rec {
  pname = "shared-memory-ring";
  version = "3.1.1";

  src = fetchurl {
    url = "https://github.com/mirage/shared-memory-ring/releases/download/v${version}/shared-memory-ring-${version}.tbz";
    sha256 = "sha256-KW8grij/OAnFkdUdRRZF21X39DvqayzkTWeRKwF8uoU=";
  };

  nativeBuildInputs = [
    ppx_cstruct
  ];

  propagatedBuildInputs = [
    mirage-profile
    cstruct
    stdlib-shims
  ];

  doCheck = true;
  checkInputs = [
    ounit
  ];

  meta = with lib; {
    description = "Shared memory rings for RPC and bytestream communications";
    license = licenses.isc;
    homepage = "https://github.com/mirage/shared-memory-ring";
    maintainers = [ maintainers.sternenseemann ];
  };
}
