{ lib
, buildPythonPackage
, fetchPypi
, hypothesis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jmespath";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kCYbIG1t79WP3V6F9Hi/YzopAXmJBr4q04kVDFxg7b4=";
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/jmespath/jmespath.py";
    description = "JMESPath allows you to declaratively specify how to extract elements from a JSON document";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
