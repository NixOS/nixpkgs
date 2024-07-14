{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  hypothesis,
  six,
  strict-rfc3339,
}:

buildPythonPackage rec {
  pname = "rfc3339-validator";
  version = "0.1.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "rfc3339_validator";
    inherit version;
    hash = "sha256-E4oqvfkzBK1gUwFn5R0t+5VJUhqDaHG4jX9GldACL2s=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    strict-rfc3339
  ];
  pythonImportsCheck = [ "rfc3339_validator" ];

  meta = with lib; {
    description = "RFC 3339 validator for Python";
    homepage = "https://github.com/naimetti/rfc3339-validator";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
