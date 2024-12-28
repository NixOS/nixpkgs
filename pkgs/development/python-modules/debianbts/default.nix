{
  lib,
  buildPythonPackage,
  fetchPypi,
  pysimplesoap,
  pythonOlder,
  setuptools,
  distutils,
}:

buildPythonPackage rec {
  pname = "python-debianbts";
  version = "4.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "python_debianbts";
    hash = "sha256-9EOxjOJBGzcxA3hHFeZwffA09I2te+OHppF7FuFU15M=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  build-system = [ setuptools ];

  dependencies = [
    pysimplesoap
    distutils
  ];

  # Most tests require network access
  doCheck = false;

  pythonImportsCheck = [ "debianbts" ];

  meta = {
    description = "Python interface to Debian's Bug Tracking System";
    mainProgram = "debianbts";
    homepage = "https://github.com/venthur/python-debianbts";
    downloadPage = "https://pypi.org/project/python-debianbts/";
    changelog = "https://github.com/venthur/python-debianbts/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
