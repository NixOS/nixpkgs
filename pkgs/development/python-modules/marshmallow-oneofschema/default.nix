{ lib
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "marshmallow-oneofschema";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
    rev = version;
    hash = "sha256-x0v8WkfjGkP2668QIQiewQViYFDIS2zBWMULcDThWas=";
  };

  propagatedBuildInputs = [
    marshmallow
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "marshmallow_oneofschema"
  ];

  meta = with lib; {
    description = "Marshmallow library extension that allows schema (de)multiplexing";
    homepage = "https://github.com/marshmallow-code/marshmallow-oneofschema";
    license = licenses.mit;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
