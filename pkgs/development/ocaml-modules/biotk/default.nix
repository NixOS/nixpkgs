{
  lib,
  buildDunePackage,
  fetchurl,
  angstrom-unix,
  binning,
  ocaml-crunch,
  camlzip,
  core_kernel,
  core_unix ? null,
  csvfields ? null,
  fmt,
  gsl,
  ppx_csv_conv ? null,
  ppx_deriving,
  rresult,
  tyxml,
  uri,
  vg,
}:

buildDunePackage (finalAttrs: {
  pname = "biotk";
  version = "0.3";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/pveber/biotk/releases/download/v${finalAttrs.version}/biotk-${finalAttrs.version}.tbz";
    hash = "sha256-9eRd3qYteUxu/xNEUER/DHodr6cTCuPtSKr38x32gig=";
  };

  nativeBuildInputs = [ ocaml-crunch ];

  buildInputs = [ ppx_csv_conv ];

  propagatedBuildInputs = [
    angstrom-unix
    binning
    camlzip
    core_kernel
    core_unix
    csvfields
    fmt
    gsl
    ppx_deriving
    rresult
    tyxml
    uri
    vg
  ];

  meta = {
    description = "Toolkit for bioinformatics in OCaml";
    license = lib.licenses.cecill-c;
  };
})
