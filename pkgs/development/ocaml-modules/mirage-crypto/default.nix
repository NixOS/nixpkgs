{ lib, fetchurl, buildDunePackage, ounit, cstruct, dune-configurator, eqaf, pkg-config }:

buildDunePackage rec {
  minimumOCamlVersion = "4.08";

  pname = "mirage-crypto";
  version = "0.8.5";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-v${version}.tbz";
    sha256 = "0l6q0z5ghhy0djfscb2i2xg4dpmxs4xkwh16kc473cmb4hsxsmyk";
  };

  useDune2 = true;

  doCheck = true;
  checkInputs = [ ounit ];

  nativeBuildInputs = [ dune-configurator pkg-config ];
  propagatedBuildInputs = [ cstruct eqaf ];

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-crypto";
    description = "Simple symmetric cryptography for the modern age";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
