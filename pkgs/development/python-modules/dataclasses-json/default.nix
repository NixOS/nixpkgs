{ lib
, buildPythonPackage
, fetchPypi
, stringcase
, typing-inspect
, marshmallow-enum
, hypothesis
, mypy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c3976816fd3cdd8db3be2b516b64fc083acd46ac22c680d3dc24cb1d6ae3367";
  };

  propagatedBuildInputs = [
    stringcase
    typing-inspect
    marshmallow-enum
  ];

  checkInputs = [
    hypothesis
    mypy
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Type annotations check failed
    "test_type_hints"
  ];

  pythonImportsCheck = [ "dataclasses_json" ];

  meta = with lib; {
    description = "Simple API for encoding and decoding dataclasses to and from JSON";
    homepage = "https://github.com/lidatong/dataclasses-json";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
  };
}
