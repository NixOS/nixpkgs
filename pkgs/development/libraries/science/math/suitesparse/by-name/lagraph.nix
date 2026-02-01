{
  lib,
  stdenv,
  mkDerivation,
  graphblas,
  llvmPackages,
}:

mkDerivation {
  pname = "lagraph";
  moduleName = "LAGraph";
  version = "1.2.1";

  buildInputs = lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  propagatedBuildInputs = [
    graphblas
  ];

  meta = {
    description = "Library plus a test harness for collecting algorithms that use GraphBLAS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
