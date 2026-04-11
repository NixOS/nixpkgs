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
  version = "0.12.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Esv0iLBlXcBaoYoMpZgt6XAwJgTkYfyS6H69m3U5tv8=";
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
