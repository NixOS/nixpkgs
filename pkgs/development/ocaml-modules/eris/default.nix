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
  version = "1.0.0-unstable-2026-09-30";

  minimalOCamlVersion = "4.14";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "eris";
    repo = "ocaml-eris";
    rev = "142882564bb587375e690182e48cb438e207173a";
    hash = "sha256-NEckZ1+oD+UWQ9aoYvjGs6ucrFenWFihYoiTHXh9ohw=";
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
