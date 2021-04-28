{ lib, fetchurl, buildDunePackage, ounit, cstruct, dune-configurator, eqaf, bigarray-compat, pkg-config
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.08";

  pname = "mirage-crypto";
  version = "0.10.1";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-v${version}.tbz";
    sha256 = "028e2fc1f0a3e9b06603c6a253ecd043100099bc1c12c0567d8bc46d3781499c";
  };

  useDune2 = true;

  doCheck = true;
  checkInputs = [ ounit ];

  nativeBuildInputs = [ dune-configurator pkg-config ];
  propagatedBuildInputs = [
    cstruct eqaf bigarray-compat
  ] ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-crypto";
    description = "Simple symmetric cryptography for the modern age";
    license = [
      licenses.isc  # default license
      licenses.bsd2 # mirage-crypto-rng-mirage
      licenses.mit  # mirage-crypto-ec
    ];
    maintainers = with maintainers; [ sternenseemann ];
  };
}
