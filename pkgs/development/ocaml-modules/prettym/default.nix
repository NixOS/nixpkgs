{ alcotest
, base64
, bigarray-overlap
, bigstringaf
, buildDunePackage
, fetchurl
, fmt
, jsonm
, ke
, lib
, ptime
}:

buildDunePackage rec {
  pname = "prettym";
  version = "0.0.3";

  src = fetchurl {
    url = "https://github.com/dinosaure/prettym/releases/download/${version}/prettym-${version}.tbz";
    hash = "sha256-kXDxoRref02YpYSlvlK7a5FBX5ccbnWJQzG0axi5jwk=";
  };

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [
    bigarray-overlap
    bigstringaf
    fmt
    ke
  ];

  checkInputs = [
    ptime
    alcotest
    jsonm
    base64
  ];
  doCheck = true;

  meta = {
    description = "A simple bounded encoder to serialize human readable values and respect the 80-column constraint";
    license = lib.licenses.mit;
    homepage = "https://github.com/dinosaure/prettym";
    maintainers = with lib.maintainers; [ ];
  };
}
