{ lib, fetchurl, buildDunePackage, ounit, cstruct, dune-configurator, pkg-config }:

buildDunePackage rec {
  minimumOCamlVersion = "4.08";

  pname = "mirage-crypto";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-v${version}.tbz";
    sha256 = "0k7kllv3bh192yj6p9dk2z81r56w7x2kyr46pxygb5gnhqqxcncf";
  };

  useDune2 = true;

  doCheck = true;
  checkInputs = [ ounit ];

  nativeBuildInputs = [ dune-configurator pkg-config ];
  propagatedBuildInputs = [ cstruct ];

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-crypto";
    description = "Simple symmetric cryptography for the modern age";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
