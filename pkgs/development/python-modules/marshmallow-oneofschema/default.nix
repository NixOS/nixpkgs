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
  version = "3.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = pname;
    rev = version;
    hash = "sha256-Em2jQmvI5IiWREeOX/JAcdOQlpwP7k+cbCirkh82sf0=";
  };

  propagatedBuildInputs = [
    marshmallow
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "marshmallow_oneofschema"
  ];

  meta = with lib; {
    changelog = "https://github.com/marshmallow-code/marshmallow-oneofschema/blob/${src.rev}/CHANGELOG.rst";
    description = "Marshmallow library extension that allows schema (de)multiplexing";
    homepage = "https://github.com/marshmallow-code/marshmallow-oneofschema";
    license = licenses.mit;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
