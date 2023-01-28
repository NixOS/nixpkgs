{ lib, fetchurl, buildDunePackage, ocaml, dune-configurator, pkg-config
, optint
, fmt, rresult, bos, fpath, astring, alcotest
, withFreestanding ? false
, ocaml-freestanding
}:

buildDunePackage rec {
  version = "0.4.0";
  pname = "checkseum";

  minimalOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/checkseum/releases/download/v${version}/checkseum-${version}.tbz";
    sha256 = "sha256-K6QPMts5+hxH2a+WQ1N0lwMBoshG2T0bSozNgzRvAlo=";
  };

  buildInputs = [ dune-configurator ];
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [
    optint
  ] ++ lib.optionals withFreestanding [
    ocaml-freestanding
  ];

  nativeCheckInputs = [
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
