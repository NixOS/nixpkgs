{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "colorlog";
  version = "6.8.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+7b9+dVoXyUX84j7Kbsn1U6GVN0x9YvCo7IX6WepXKY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorlog" ];

  meta = with lib; {
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
