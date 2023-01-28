{ lib, buildDunePackage, fetchurl, cstruct, mirage-crypto, alcotest }:

buildDunePackage rec {
  pname = "hkdf";
  version = "1.0.4";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/hannesm/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0nzx6vzbc1hh6vx1ly8df4b16lgps6zjpp9mjycsnnn49bddc9mr";
  };

  useDune2 = true;

  propagatedBuildInputs = [ cstruct mirage-crypto ];
  nativeCheckInputs = [ alcotest ];
  doCheck = true;

  meta = with lib; {
    description = "HMAC-based Extract-and-Expand Key Derivation Function (RFC 5869)";
    homepage = "https://github.com/hannesm/ocaml-hkdf";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
