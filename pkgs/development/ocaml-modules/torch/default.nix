{ lib
, stdenv
, buildDunePackage
, fetchFromGitHub
, cmdliner
, ctypes
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
  version = "0.10";

  minimumOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "LaurentMazare";
    repo   = "ocaml-${pname}";
    rev    = version;
    sha256 = "1rqrv6hbical8chk0bl2nf60q6m4b5d1gab9fc5q03vkz2987f9b";
  };

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

  preBuild = ''export LIBTORCH=${pytorch.dev}/'';

  doCheck = !stdenv.isAarch64;
  checkPhase = "dune runtest";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Ocaml bindings to Pytorch";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.asl20;
  };
}
