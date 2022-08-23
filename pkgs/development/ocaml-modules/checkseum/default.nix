{ lib, fetchurl, buildDunePackage, ocaml, dune-configurator, pkg-config
, bigarray-compat, optint
, fmt, rresult, bos, fpath, astring, alcotest
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  version = "0.3.2";
  pname = "checkseum";

  useDune2 = true;

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/checkseum/releases/download/v${version}/checkseum-v${version}.tbz";
    sha256 = "9cdd282ea1cfc424095d7284e39e4d0ad091de3c3f2580539d03f6966d45ccd5";
  };

  buildInputs = [ dune-configurator ];
  nativeBuildInputs = [ pkg-config ];
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

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "ADLER-32 and CRC32C Cyclic Redundancy Check";
    homepage = "https://github.com/mirage/checkseum";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "checkseum.checkseum";
  };
}
