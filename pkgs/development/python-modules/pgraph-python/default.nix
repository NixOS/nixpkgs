{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ansitable,
  matplotlib,
  numpy,
  spatialmath-python,
  pytest,
  pytest-cov,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pgraph-python";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SrrX3tkGd+TR/IMX3imMcGiUL4sonsmli/PTbWZucM8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    ansitable
    matplotlib
    numpy
    spatialmath-python
  ];

  passthru.optional-dependencies = {
    dev = [
      pytest
      pytest-cov
    ];
  };

  pythonImportsCheck = [ "pgraph" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Mathematical graphs for Python";
    homepage = "https://pypi.org/project/pgraph-python/";
    license = licenses.mit;
    maintainers = with maintainers; [
      djacu
      a-camarillo
    ];
  };
}
