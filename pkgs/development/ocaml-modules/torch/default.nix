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
  version = "0.11";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "LaurentMazare";
    repo   = "ocaml-${pname}";
    rev    = version;
    sha256 = "19zbl9zn6fslrcm6x9cis6nswhwz8mc57nrhkada658n7rcdmskr";
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
  };
}
