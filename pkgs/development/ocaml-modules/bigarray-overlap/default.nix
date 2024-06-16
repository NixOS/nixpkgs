{ lib, buildDunePackage, fetchurl
, alcotest, pkg-config
}:

buildDunePackage rec {
  pname = "bigarray-overlap";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/dinosaure/overlap/releases/download/v${version}/bigarray-overlap-${version}.tbz";
    hash = "sha256-L1IKxHAFTjNYg+upJUvyi2Z23bV3U8+1iyLPhK4aZuA=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  nativeBuildInputs = [ pkg-config ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/dinosaure/overlap";
    description = "A minimal library to know that 2 bigarray share physically the same memory or not";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
