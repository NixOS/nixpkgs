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
  version = "0.15";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "LaurentMazare";
    repo   = "ocaml-${pname}";
    rev    = version;
    sha256 = "sha256-EXJqlAGa0LwQKY8IlmcoJs0l2eRTiUhuzMHfakrslXU=";
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
