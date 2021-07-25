{ lib, fetchFromGitLab, buildDunePackage, ff, zarith, ctypes, tezos-rust-libs, alcotest }:

buildDunePackage rec {
  pname = "bls12-381";
  version = "0.3.15";

  src = fetchFromGitLab {
    owner = "dannywillems";
    repo = "ocaml-bls12-381";
    rev = version;
    sha256 = "1s8n657fsl2gs01p7v2ffpcfzymavifhhpriyx1gq5qh4zvvw4vr";
  };
  useDune2 = true;

  minimalOCamlVersion = "4.08";
  propagatedBuildInputs = [
    ff
    zarith
    ctypes
    tezos-rust-libs
  ];

  checkInputs = [
    alcotest
  ];

  # This is a hack to work around the hack used in the dune files
  OPAM_SWITCH_PREFIX = "${tezos-rust-libs}";

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/dannywillems/ocaml-bls12-381";
    description = "OCaml binding for bls12-381 from librustzcash";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
