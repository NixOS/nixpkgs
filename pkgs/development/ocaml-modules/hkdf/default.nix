{
  lib,
  buildDunePackage,
  fetchurl,
  digestif,
  alcotest,
  ohex,
}:

buildDunePackage rec {
  pname = "hkdf";
  version = "2.0.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/hannesm/ocaml-${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-VLBxJ5viTTn1nK0QNIAGq/8961x0/RGHZN/C/7ITWNM=";
  };

  propagatedBuildInputs = [ digestif ];
  checkInputs = [
    alcotest
    ohex
  ];
  doCheck = true;

  meta = with lib; {
    description = "HMAC-based Extract-and-Expand Key Derivation Function (RFC 5869)";
    homepage = "https://github.com/hannesm/ocaml-hkdf";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
