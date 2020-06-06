{ lib, buildDunePackage, fetchurl, benchmark, cstruct
, eqaf, hex, ppx_blob, ppx_deriving_yojson, stdlib-shims, yojson }:

buildDunePackage rec {
  pname = "hacl_x25519";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/mirage/hacl/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "187khbx1myh942c2v5f7wbms2hmhmgn57ik25djhnryln32c0874";
  };

  propagatedBuildInputs = [ eqaf cstruct ];
  checkInputs = [ benchmark hex ppx_blob ppx_deriving_yojson stdlib-shims yojson ];
  doCheck = true;

  meta = with lib; {
    description = "Primitives for Elliptic Curve Cryptography taken from Project Everest";
    homepage = "https://github.com/mirage/hacl";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
