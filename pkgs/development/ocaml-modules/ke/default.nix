{ lib, buildDunePackage, fetchurl
, bigarray-compat, fmt
, alcotest, bigstringaf
}:

buildDunePackage rec {
  pname = "ke";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/mirage/ke/releases/download/v${version}/ke-${version}.tbz";
    sha256 = "sha256-YSFyB+IgCwSxd1lzZhD/kggmmmR/hUy1rnLNrA1nIwU=";
  };

  propagatedBuildInputs = [ fmt ];

  checkInputs = [ alcotest bigstringaf ];
  doCheck = true;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  meta = {
    description = "Fast implementation of queue in OCaml";
    homepage = "https://github.com/mirage/ke";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
