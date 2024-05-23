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
    sha256 = "0srg0b89aikzinw72s433994k5gv5lfyarq1adhas11kz6yjm2hk";
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
