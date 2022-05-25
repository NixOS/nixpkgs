{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "apipkg";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zKNAIkFKE5duM6HjjWoJBWfve2jQNy+SPGmaj4wIivw=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "apipkg"
  ];

  meta = with lib; {
    description = "Namespace control and lazy-import mechanism";
    homepage = "https://github.com/pytest-dev/apipkg";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
