{
  lib,
  fetchurl,
  fetchpatch,
  buildDunePackage,
  pkg-config,
  dune-configurator,
  stdio,
  R,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "ocaml-r";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/pveber/ocaml-r/releases/download/v${finalAttrs.version}/ocaml-r-${finalAttrs.version}.tbz";
    hash = "sha256-nbO36z/bSMb2vQjW5A9O2hjuF2RVzefFN53l/u3KF+o=";
  };

  # Compatibility with R 4.6
  patches = [
    (fetchpatch {
      url = "https://github.com/pveber/ocaml-r/commit/c70704dd9ff1ed6b4035beef3316dc95275aaf4f.patch";
      hash = "sha256-I3SX+6gVo9l7epeFhtae8Ji4q51mr53sv7MPxvRBdJg=";
    })
    (fetchpatch {
      url = "https://github.com/pveber/ocaml-r/commit/c90ce656bd55236e74907f2ef5bc70ff11a0cedc.patch";
      hash = "sha256-ACU4d8Npq1IXR3hysk6npHHU8ZRcAgRkHg/c+Sb8dkM=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    R
  ];
  buildInputs = [
    dune-configurator
    stdio
    R
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "OCaml bindings for the R interpreter";
    homepage = "https://github.com/pveber/ocaml-r/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.bcdarwin ];
  };

})
