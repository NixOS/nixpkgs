{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  zeep,
}:

buildPythonPackage rec {
  pname = "python-stdnum";
  version = "2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "python_stdnum";
    inherit version;
    hash = "sha256-awFkWWnrPf1VBhoBFNWTdTzZ5lPOqQgxmLfuoSZEOXo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  optional-dependencies = {
    SOAP = [ zeep ];
  };

  pythonImportsCheck = [ "stdnum" ];

  meta = with lib; {
    description = "Python module to handle standardized numbers and codes";
    homepage = "https://arthurdejong.org/python-stdnum/";
    changelog = "https://github.com/arthurdejong/python-stdnum/blob/${version}/ChangeLog";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ johbo ];
  };
}
