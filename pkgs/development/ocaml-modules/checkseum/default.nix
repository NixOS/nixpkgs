{ lib, fetchurl, buildDunePackage, dune-configurator, pkg-config
, bigarray-compat, optint
, fmt, rresult, bos, fpath, astring, alcotest
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  version = "0.3.1";
  pname = "checkseum";

  useDune2 = true;

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/checkseum/releases/download/v${version}/checkseum-v${version}.tbz";
    sha256 = "b9e4d054e17618b1faed8c0eb15afe0614b2f093e58b59a180bda4500a5d2da1";
  };

  patches = [
    ./makefile-no-opam.patch
  ];

  nativeBuildInputs = [
    dune-configurator
    pkg-config
  ];
  propagatedBuildInputs = [
    bigarray-compat
    optint
  ] ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

  checkInputs = [
    alcotest
    bos
    astring
    fmt
    fpath
    rresult
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/checkseum";
    description = "ADLER-32 and CRC32C Cyclic Redundancy Check";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
