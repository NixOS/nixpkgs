{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  ruamel-yaml,
  attrs,
  pytest7CheckHook,
  pytest-cov-stub,
  pytest-xdist,
  numpy,
}:

buildPythonPackage rec {
  pname = "demes";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nmE7ZbR126J3vKdR3h83qJ/V602Fa6J3M6IJnIqCNhc=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    ruamel-yaml
    attrs
  ];

  nativeCheckInputs = [
    pytest7CheckHook
    pytest-cov-stub
    pytest-xdist
    numpy
  ];

  disabledTestPaths = [ "tests/test_spec.py" ];

  pythonImportsCheck = [ "demes" ];

  meta = {
    description = "Tools for describing and manipulating demographic models";
    mainProgram = "demes";
    homepage = "https://github.com/popsim-consortium/demes-python";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
