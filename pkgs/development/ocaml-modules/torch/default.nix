{ stdenv
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
  version = "0.8";

  owner = "LaurentMazare";

  minimumOCamlVersion = "4.07";

  src = fetchFromGitHub {
    inherit owner;
    repo   = "ocaml-${pname}";
    rev    = version;
    sha256 = "19w31paj24pns2ahk9j9rgpkb5hpcd41kfaarxrlddww5dl6pxvi";
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

  doCheck = true;
  checkPhase = "dune runtest";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Ocaml bindings to Pytorch";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.asl20;
  };
}
