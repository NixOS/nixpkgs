{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  cython,
  setuptools,
  setuptools-scm,
  wheel,
  numpy,
  scipy,
  matplotlib,
  networkx,
  nibabel,
}:

buildPythonPackage rec {
  pname = "nitime";
  version = "0.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4Ie8fuk9CKdn/64TsCfN2No2dU16ICpBRWYerqqF0/0=";
  };

  nativeBuildInputs = [
    cython
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
    networkx
    nibabel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = !stdenv.hostPlatform.isDarwin; # tests hang indefinitely

  pythonImportsCheck = [ "nitime" ];

  meta = {
    homepage = "https://nipy.org/nitime";
    description = "Algorithms and containers for time-series analysis in time and spectral domains";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
