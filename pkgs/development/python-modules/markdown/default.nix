{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, importlib-metadata
, pyyaml
, setuptools
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "markdown";
  version = "3.5.1";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Python-Markdown";
    repo = "markdown";
    rev = "refs/tags/${version}";
    hash = "sha256-OeCr72N3ygYYJnI+bIXCt63tSLDFLKznYekTk1sYHZI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [ unittestCheckHook pyyaml ];

  pythonImportsCheck = [ "markdown" ];

  meta = with lib; {
    changelog = "https://github.com/Python-Markdown/markdown/blob/${src.rev}/docs/changelog.md";
    description = "Python implementation of John Gruber's Markdown";
    homepage = "https://github.com/Python-Markdown/markdown";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
