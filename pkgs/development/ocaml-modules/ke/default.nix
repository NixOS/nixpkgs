{ lib, buildDunePackage, fetchurl
, bigarray-compat, fmt
, alcotest, bigstringaf
}:

buildDunePackage rec {
  pname = "ke";
  version = "0.6";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ke/releases/download/v${version}/ke-${version}.tbz";
    sha256 = "sha256-YSFyB+IgCwSxd1lzZhD/kggmmmR/hUy1rnLNrA1nIwU=";
  };

  propagatedBuildInputs = [ fmt ];

  checkInputs = [ alcotest bigstringaf ];
  doCheck = true;

  minimumOCamlVersion = "4.03";

  meta = {
    description = "Fast implementation of queue in OCaml";
    homepage = "https://github.com/mirage/ke";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
