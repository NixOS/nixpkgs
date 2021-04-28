{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, hypothesis
, six
, strict-rfc3339
}:

buildPythonPackage rec {
  pname = "rfc3339-validator";
  version = "0.1.3";

  src = fetchPypi {
    pname = "rfc3339_validator";
    inherit version;
    sha256 = "7a578aa0740e9ee2b48356fe1f347139190c4c72e27f303b3617054efd15df32";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytestCheckHook hypothesis strict-rfc3339 ];
  pythonImportsCheck = [ "rfc3339_validator" ];

  meta = with lib; {
    description = "RFC 3339 validator for Python";
    homepage = "https://github.com/naimetti/rfc3339-validator";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
