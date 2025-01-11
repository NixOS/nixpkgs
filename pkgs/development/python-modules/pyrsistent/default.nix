{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  setuptools,
  six,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "pyrsistent";
  version = "0.20.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TEj3j2KrWWxnkIYITQ3RMlSuTz1scqg//fXr3vjyZaQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "pyrsistent" ];

  meta = with lib; {
    homepage = "https://github.com/tobgu/pyrsistent/";
    description = "Persistent/Functional/Immutable data structures";
    license = licenses.mit;
    maintainers = with maintainers; [ desiderius ];
  };
}
