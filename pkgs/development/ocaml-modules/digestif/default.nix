{ lib, fetchurl, fetchpatch, buildDunePackage
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

  # Fix tests with alcotest ≥ 1
  patches = [ (fetchpatch {
    url = "https://github.com/mirage/digestif/commit/b65d996c692d75da0a81323253429e07d14b72b6.patch";
    sha256 = "0sf7qglcp19dhs65pwrrc7d9v57icf18jsrhpmvwskx8b4dchfiv";
  })];

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
