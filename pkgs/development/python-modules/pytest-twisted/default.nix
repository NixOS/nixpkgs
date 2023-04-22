{ lib
, buildPythonPackage
, fetchPypi
, greenlet
, pytest
, decorator
, twisted
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-twisted";
  version = "1.14.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IJv1pkUs+/th3o8BWQLBTsgSZACRFQcHS7LuTOjf4xM=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    decorator
    greenlet
  ];

  nativeCheckInputs = [
    pytestCheckHook
    twisted
  ];

  pythonImportsCheck = [
    "pytest_twisted"
  ];

  meta = with lib; {
    description = "A twisted plugin for py.test";
    homepage = "https://github.com/pytest-dev/pytest-twisted";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
