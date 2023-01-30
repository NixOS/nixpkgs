{ lib, buildDunePackage, fetchurl, cstruct, mirage-crypto, alcotest }:

buildDunePackage rec {
  pname = "hkdf";
  version = "1.0.4";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/hannesm/ocaml-${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    hash = "sha256-uSbW2krEWquZlzXdK7/R91ETFnENeRr6NhAGtv42/Vs=";
  };

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
