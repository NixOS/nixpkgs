{
  lib,
  fetchurl,
  buildDunePackage,
  digestif,
  sexplib0,
  mirage-crypto,
  mirage-crypto-pk,
  astring,
  base64,
}:

buildDunePackage rec {
  pname = "otr";
  version = "1.0.0";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/hannesm/ocaml-otr/releases/download/v${version}/otr-${version}.tbz";
    hash = "sha256-/CcVqLbdylB+LqpKNETkpvQ8SEAIcEFCO1MZqvdmJWU=";
  };

  propagatedBuildInputs = [
    digestif
    sexplib0
    mirage-crypto
    mirage-crypto-pk
    astring
    base64
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/hannesm/ocaml-otr";
    description = "Off-the-record messaging protocol, purely in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
