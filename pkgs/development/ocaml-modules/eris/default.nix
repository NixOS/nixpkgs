{
  lib,
  buildDunePackage,
  fetchFromCodeberg,
  unstableGitUpdater,
  zig,
  ctypes,
  fmt,
  base32,
  monocypher,
  js_of_ocaml,
  crunch,
  lwt,
  cborl,
  benchmark,
  bos,
  decoders-yojson,
  alcotest,
  qcheck,
  qcheck-alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "eris";
  version = "1.0.0-unstable-2026-03-11";

  minimalOCamlVersion = "4.14";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "eris";
    repo = "ocaml-eris";
    rev = "ced19e6054b4fcf546930a9ecee06055908c0b73";
    hash = "sha256-Yng7liiDS3Pupr9c4J5vNIyomxwjPLn2GJHIO12rIWc=";
  };

  dunePackages = [
    "eris"
    "eris-lwt"
    "eris_cbor"
  ];

  nativeBuildInputs = [
    zig
    crunch
  ];

  propagatedBuildInputs = [
    ctypes
    fmt
    base32
    monocypher
    js_of_ocaml
    lwt
    cborl
  ];

  doCheck = true;
  checkInputs = [
    benchmark
    bos
    decoders-yojson
    alcotest
    qcheck
    qcheck-alcotest
  ];

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "OCaml implementation of the Encoding for Robust Immutable Storage (ERIS)";
    homepage = "https://codeberg.org/eris/ocaml-eris";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    teams = [ lib.teams.ngi ];
  };
})
