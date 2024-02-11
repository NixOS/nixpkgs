{ lib
, stdenv
, buildDunePackage
, fetchFromGitHub
, fetchpatch
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

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "LaurentMazare";
    repo = "ocaml-${pname}";
    rev = version;
    hash = "sha256-z/9NUBjeFWE63Z/e8OyzDiy8hrn6qzjaiBH8G9MPeos=";
  };

  patches = [
    # Pytorch 2.0 support. Drop when it reaches a release
    (fetchpatch {
      url = "https://github.com/LaurentMazare/ocaml-torch/commit/ef7ef30cafecb09e45ec1ed8ce4bedae5947cfa5.patch";
      hash = "sha256-smdwKy40iIISp/25L2J4az6KmqFS1soeChBElUyhl5A=";
    })
  ];

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

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Ocaml bindings to Pytorch";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.asl20;
  };
}
