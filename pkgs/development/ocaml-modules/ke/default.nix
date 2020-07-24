{ lib, buildDunePackage, fetchurl
, bigarray-compat, fmt
, alcotest, bigstringaf
}:

buildDunePackage rec {
  pname = "ke";
  version = "0.4";

  src = fetchurl {
    url = "https://github.com/mirage/ke/releases/download/v${version}/ke-v${version}.tbz";
    sha256 = "13c9xy60vmq29mnwpg3h3zgl6gjbjfwbx1s0crfc6xwvark0zxnx";
  };

  propagatedBuildInputs = [ bigarray-compat fmt ];

  checkInputs = lib.optionals doCheck [ alcotest bigstringaf ];
  doCheck = true;

  minimumOCamlVersion = "4.03";

  meta = {
    description = "Fast implementation of queue in OCaml";
    homepage = "https://github.com/mirage/ke";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
