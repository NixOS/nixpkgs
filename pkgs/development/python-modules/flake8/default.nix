{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  mccabe,
  pycodestyle,
  pyflakes,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "7.1.1";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "flake8";
    rev = version;
    hash = "sha256-6iCZEapftHqd9okJS1wMzIjjmWahrmmZtXd7SUMVcmE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mccabe
    pycodestyle
    pyflakes
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/PyCQA/flake8/blob/${src.rev}/docs/source/release-notes/${version}.rst";
    description = "Modular source code checker: pep8, pyflakes and co";
    homepage = "https://github.com/PyCQA/flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "flake8";
  };
}
