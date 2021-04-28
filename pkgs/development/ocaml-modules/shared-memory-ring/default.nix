{ lib
, buildDunePackage
, fetchurl
, ppx_cstruct
, mirage-profile
, cstruct
, ounit
}:

buildDunePackage rec {
  pname = "shared-memory-ring";
  version = "3.1.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/shared-memory-ring/releases/download/v${version}/shared-memory-ring-v${version}.tbz";
    sha256 = "06350ph3rdfvybi0cgs3h3rdkmjspk3c4375rxvbdg0kza1w22x1";
  };

  nativeBuildInputs = [
    ppx_cstruct
  ];

  propagatedBuildInputs = [
    mirage-profile
    cstruct
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
