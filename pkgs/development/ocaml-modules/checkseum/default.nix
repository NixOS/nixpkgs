{ lib, fetchurl, buildDunePackage, dune-configurator, pkg-config
, bigarray-compat, optint
, fmt, rresult, bos, fpath, astring, alcotest
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  version = "0.3.4";
  pname = "checkseum";

  useDune2 = true;

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/checkseum/releases/download/v${version}/checkseum-${version}.tbz";
    sha256 = "0f6p7rpankr13m56j9kxn7qndss9s44f3np673j1lfap1hxh3gh4";
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

  doCheck = true;

  meta = {
    description = "ADLER-32 and CRC32C Cyclic Redundancy Check";
    homepage = "https://github.com/mirage/checkseum";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "checkseum.checkseum";
  };
}
