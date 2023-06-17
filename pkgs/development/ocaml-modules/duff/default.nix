{ lib
, fetchurl
, buildDunePackage
, fmt
, alcotest
, hxd
, crowbar
, bigstringaf
}:

buildDunePackage rec {
  pname = "duff";
  version = "0.5";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/duff/releases/download/v${version}/duff-${version}.tbz";
    sha256 = "sha256-0eqpfPWNOHYjkcjXRnZUTUFF0/L9E+TNoOqKCETN5hI=";
  };

  propagatedBuildInputs = [ fmt ];

  doCheck = true;
  checkInputs = [
    alcotest
    crowbar
    hxd
    bigstringaf
  ];


  meta = {
    description = "Pure OCaml implementation of libXdiff (Rabin’s fingerprint)";
    homepage = "https://github.com/mirage/duff";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
