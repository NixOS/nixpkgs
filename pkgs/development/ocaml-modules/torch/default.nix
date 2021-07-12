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
, pytorch
}:

buildDunePackage rec {
  pname = "torch";
  version = "0.12";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "LaurentMazare";
    repo   = "ocaml-${pname}";
    rev    = version;
    sha256 = "0nl6hd2rivhgkc3sdkdmrk3j0ij3xjx1clhqm8m5iznir4g77g91";
  };

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [
    cmdliner
    ctypes
    npy
    ocaml-compiler-libs
    pytorch
    pytorch.dev
    ppx_custom_printf
    ppx_expect
    ppx_sexp_conv
    sexplib
    stdio
  ];

  preBuild = "export LIBTORCH=${pytorch.dev}/";

  doCheck = !stdenv.isAarch64;
  checkPhase = "dune runtest";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Ocaml bindings to Pytorch";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.asl20;
    broken = true;
  };
}
