{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colorlog";
  version = "6.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+7b9+dVoXyUX84j7Kbsn1U6GVN0x9YvCo7IX6WepXKY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "colorlog"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
