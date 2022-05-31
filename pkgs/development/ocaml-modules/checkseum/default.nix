{ lib, fetchurl, buildDunePackage, dune-configurator, pkg-config
, bigarray-compat, optint
, fmt, rresult, bos, fpath, astring, alcotest
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  version = "0.3.3";
  pname = "checkseum";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/checkseum/releases/download/v${version}/checkseum-${version}.tbz";
    sha256 = "sha256-wqx/czLchr2vZ/945/1rxAFvX6VWsINRbbnQxA6uiBE=";
  };

  buildInputs = [ dune-configurator ];
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [
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
    description = "ADLER-32 and CRC32C Cyclic Redundancy Check";
    homepage = "https://github.com/mirage/checkseum";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "checkseum.checkseum";
  };
}
