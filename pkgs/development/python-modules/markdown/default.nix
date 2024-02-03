{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, importlib-metadata
, pyyaml
, setuptools
, unittestCheckHook
, wheel
}:

buildPythonPackage rec {
  pname = "markdown";
  version = "3.4.4";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Python-Markdown";
    repo = "markdown";
    rev = "refs/tags/${version}";
    hash = "sha256-5PIIhbJVsotGwZ3BQ4x0I7WjgnGF3opNrn8J+xZCflg=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [ unittestCheckHook pyyaml ];

  pythonImportsCheck = [ "markdown" ];

  meta = with lib; {
    changelog = "https://github.com/Python-Markdown/markdown/blob/${src.rev}/docs/change_log/index.md";
    description = "Python implementation of John Gruber's Markdown";
    homepage = "https://github.com/Python-Markdown/markdown";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
