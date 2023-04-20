{ lib
, pkgs
, stdenv

  # Build-time dependencies:
, buildBazelPackage
, fetchFromGitHub
, bazel_5

  # Python dependencies:

  # Runtime dependencies:

  # CUDA flags:
, cudaSupport ? false
, cudaPackages ? {}

  # MKL:
, mklSupport ? true
}:

buildBazelPackage {

  pname = "xla";
  version = "unstable-2023-04-20";

  bazel = bazel_5;

  src = fetchFromGitHub {
    owner = "openxla";
    repo = "xla";
    rev = "2ff01e572618fad7169ebb347c186176fb049bf2";
    hash = "";
  };

  meta = with lib; {
    description = "XLA (Accelerated Linear Algebra) is an open-source machine learning (ML) compiler for GPUs, CPUs, and ML accelerators.";
    homepage = "https://github.com/openxla/xla";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = platforms.unix;
  };
}
