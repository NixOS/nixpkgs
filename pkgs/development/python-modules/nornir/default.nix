{ lib
, fetchFromGitHub
, buildPythonPackage
, typing-extensions
, ruamel-yaml
, mypy-extensions
, pytestCheckHook
, poetry
}:

buildPythonPackage rec {
  pname = "nornir";
  version = "3.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nornir-automation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aW5o1thZlGL/T0DTiAt+jQ3Z2AnIXozAjgY+BsNqQq8=";
  };

  propagatedBuildInputs = [
    mypy-extensions
    ruamel-yaml
    typing-extensions
    poetry
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nornir" ];

  meta = with lib; {
    description = "Pluggable multi-threaded framework with inventory management to help operate collections of devices";
    homepage = "https://github.com/nornir-automation/nornir";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
