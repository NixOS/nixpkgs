{ lib, buildDunePackage, fetchurl, benchmark, cstruct
, alcotest , eqaf, hex, ppx_blob, ppx_deriving_yojson, stdlib-shims, yojson }:

buildDunePackage rec {
  pname = "hacl_x25519";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/mirage/hacl/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0ppq56i2yhxzz38w120aynnkx10kncl86zvqip9zx0v4974k3k4x";
  };

  useDune2 = true;
  propagatedBuildInputs = [ eqaf cstruct ];
  checkInputs = [ alcotest benchmark hex ppx_blob ppx_deriving_yojson stdlib-shims yojson ];
  doCheck = true;

  meta = with lib; {
    description = "Primitives for Elliptic Curve Cryptography taken from Project Everest";
    homepage = "https://github.com/mirage/hacl";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
