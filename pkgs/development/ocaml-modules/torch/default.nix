{ lib
, stdenv
, buildDunePackage
, fetchFromGitHub
, cmdliner
, ctypes
, dune-configurator
, npy
, ocaml-compiler-libs
, ppx_custom_printf
, ppx_expect
, ppx_sexp_conv
, sexplib
, stdio
, torch
}:

buildDunePackage rec {
  pname = "torch";
  version = "0.14";

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "LaurentMazare";
    repo   = "ocaml-${pname}";
    rev    = version;
    sha256 = "sha256:039anfvzsalbqi5cdp95bbixcwr2ngharihgd149hcr0wa47y700";
  };

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [
    cmdliner
    ctypes
    npy
    ocaml-compiler-libs
    ppx_custom_printf
    ppx_expect
    ppx_sexp_conv
    sexplib
    stdio
    torch
    torch.dev
  ];

  preBuild = "export LIBTORCH=${torch.dev}/";

  doCheck = !stdenv.isAarch64;
  checkPhase = "dune runtest";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Ocaml bindings to Pytorch";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.asl20;
    broken = lib.versionAtLeast torch.version "1.11";
  };
}
