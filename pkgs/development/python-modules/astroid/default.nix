{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  typing-extensions,
  pip,
  pylint,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "3.1.0"; # Check whether the version is compatible with pylint
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "astroid";
    rev = "refs/tags/v${version}";
    hash = "sha256-+cTQHbqoucaNi7rPoyH6Cu07vZMS8KWn5C/A3NXRSwE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  nativeCheckInputs = [
    pip
    pytestCheckHook
  ];

  passthru.tests = {
    inherit pylint;
  };

  meta = with lib; {
    changelog = "https://github.com/PyCQA/astroid/blob/${src.rev}/ChangeLog";
    description = "An abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
