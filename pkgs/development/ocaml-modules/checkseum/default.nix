{ lib, fetchurl, buildDunePackage, ocaml, dune-configurator
, optint
, fmt, rresult, bos, fpath, astring, alcotest
}:

buildDunePackage rec {
  version = "0.5.2";
  pname = "checkseum";

  minimalOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/checkseum/releases/download/v${version}/checkseum-${version}.tbz";
    hash = "sha256-nl5P1EBctKi03wCHdUMlGDPgimSZ70LMuNulgt8Nr8g=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    optint
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
