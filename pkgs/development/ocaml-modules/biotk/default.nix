{
  lib,
  buildDunePackage,
  fetchurl,
  angstrom-unix,
  binning,
  ocaml-crunch,
  camlzip,
  core_kernel,
  core_unix,
  csvfields,
  fmt,
  gsl,
  ppx_csv_conv,
  ppx_deriving,
  rresult,
  tyxml,
  uri,
  vg,
}:

buildDunePackage rec {
  pname = "biotk";
  version = "0.2.0";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/pveber/biotk/releases/download/v${version}/biotk-${version}.tbz";
    hash = "sha256-FQvbVj5MmraSN6AmOckKgJ/LB14E/pCsPvPvNppcv7A=";
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
}
