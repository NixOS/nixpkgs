{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bracex";
  version = "2.4";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-on6vHfQs9WH+1Yt6jz/fEp0eoWqB4frdHReYm8Y4S+s=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bracex" ];

  meta = with lib; {
    description = "Bash style brace expansion for Python";
    homepage = "https://github.com/facelessuser/bracex";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
