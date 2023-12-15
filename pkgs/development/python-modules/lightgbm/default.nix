{ lib
, stdenv
, buildPythonPackage
, fetchPypi

# build-system
, cmake
, ninja
, pathspec
, pyproject-metadata
, scikit-build-core

# dependencies
, llvmPackages
, numpy
, scipy
, scikit-learn
, pythonOlder

# optionals: gpu
, boost
, cudatoolkit
, ocl-icd
, opencl-headers
, gpuSupport ? stdenv.isLinux
}:

buildPythonPackage rec {
  pname = "lightgbm";
  version = "4.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vuWd0mmpOwk/LGENSmaDp+qHxj0+o1xiISPOLAILKrw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pathspec
    pyproject-metadata
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = (lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ]) ++ (lib.optionals gpuSupport [
    boost
    cudatoolkit
    ocl-icd
    opencl-headers
  ]);

  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
  ];

  pypaBuildFlags = lib.optionalString gpuSupport "--config-setting=cmake.define.USE_CUDA=ON";

  postConfigure = ''
    export HOME=$(mktemp -d)
  '';

  # The pypi package doesn't distribute the tests from the GitHub
  # repository. It contains c++ tests which don't seem to wired up to
  # `make check`.
  doCheck = false;

  pythonImportsCheck = [
    "lightgbm"
  ];

  meta = {
    description = "A fast, distributed, high performance gradient boosting (GBDT, GBRT, GBM or MART) framework";
    homepage = "https://github.com/Microsoft/LightGBM";
    changelog = "https://github.com/microsoft/LightGBM/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teh ];
  };
}
