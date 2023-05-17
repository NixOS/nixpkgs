{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, cmake
, numpy
, scipy
, scikit-learn
, llvmPackages ? null
, pythonOlder
, python
, ocl-icd
, opencl-headers
, boost
, gpuSupport ? true
}:

buildPythonPackage rec {
  pname = "lightgbm";
  version = "3.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ELj73PhR5PaKHwLzjZm9xEx8f7mxpi3PkkoNKf9zOVw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  dontUseCmakeConfigure = true;

  buildInputs = (lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ]) ++ (lib.optionals gpuSupport [
    boost
    ocl-icd
    opencl-headers
  ]);

  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
  ];

  buildPhase = ''
    ${python.pythonForBuild.interpreter} setup.py bdist_wheel ${lib.optionalString gpuSupport "--gpu"}
  '';

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
    maintainers = with lib.maintainers; [ teh costrouc ];
  };
}
