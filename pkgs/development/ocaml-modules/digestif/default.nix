{ lib, fetchurl, buildDunePackage
, bigarray-compat, eqaf, stdlib-shims
, alcotest
}:

buildDunePackage rec {
  pname = "digestif";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${version}/digestif-v${version}.tbz";
    sha256 = "09g4zngqiw97cljv8ds4m063wcxz3y7c7vzaprsbpjzi0ja5jdcy";
  };

  buildInputs = lib.optional doCheck alcotest;
  propagatedBuildInputs = [ bigarray-compat eqaf stdlib-shims ];

  doCheck = true;

  meta = {
    description = "Simple hash algorithms in OCaml";
    homepage = "https://github.com/mirage/digestif";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
