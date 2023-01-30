{ alcotest
, base64
, bigarray-compat
, bigarray-overlap
, bigstringaf
, buildDunePackage
, fetchzip
, fmt
, jsonm
, ke
, lib
, ptime
}:

buildDunePackage rec {
  pname = "prettym";
  version = "0.0.2";

  src = fetchzip {
    url = "https://github.com/dinosaure/prettym/releases/download/${version}/prettym-${version}.tbz";
    sha256 = "03x7jh62mvzc6x2d8xsy456qa6iphw72zm7jmqrakpmsy6zcf2lb";
  };

  useDune2 = true;

  propagatedBuildInputs = [
    bigarray-compat
    bigarray-overlap
    bigstringaf
    fmt
    ke
  ];

  nativeCheckInputs = [
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
