{ lib, fetchurl, buildDunePackage, ounit, cstruct, dune-configurator, eqaf, bigarray-compat, pkg-config
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  minimumOCamlVersion = "4.08";

  pname = "mirage-crypto";
  version = "0.10.3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-v${version}.tbz";
    sha256 = "a27910365d59b02c3f0e8a40d93a5b81835acf832e1ffa596ee772b41e8a900b";
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
