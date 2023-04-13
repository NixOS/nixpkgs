{ lib
, astroid
, buildPythonPackage
, fetchFromGitHub
, packaging
, poetry-core
, poetry-semver
, pytestCheckHook
, pythonOlder
, toml
}:

buildPythonPackage rec {
  pname = "requirements-detector";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "landscapeio";
    repo = pname;
    rev = version;
    hash = "sha256-H+h/PN1TrlpDRgI7tMWUhXlxj4CChwcxIR/BvyO261c=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    astroid
    packaging
    poetry-semver
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "requirements_detector"
  ];

  meta = with lib; {
    description = "Python tool to find and list requirements of a Python project";
    homepage = "https://github.com/landscapeio/requirements-detector";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
