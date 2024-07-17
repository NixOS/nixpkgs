{
  lib,
  fetchurl,
  buildDunePackage,
  cstruct,
  sexplib0,
  mirage-crypto,
  mirage-crypto-pk,
  astring,
  base64,
}:

buildDunePackage rec {
  pname = "otr";
  version = "0.3.10";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/hannesm/ocaml-otr/releases/download/v${version}/otr-v${version}.tbz";
    hash = "sha256:0dssc7p6s7z53n0mddyipjghzr8ld8bb7alaxqrx9gdpspwab1gq";
  };

  duneVersion = "3";

  propagatedBuildInputs = [
    cstruct
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
