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
  version = "0.17";

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "LaurentMazare";
    repo   = "ocaml-${pname}";
    rev    = version;
    hash = "sha256-z/9NUBjeFWE63Z/e8OyzDiy8hrn6qzjaiBH8G9MPeos=";
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
  };
}
