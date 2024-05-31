{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  glibcLocales,
  pycodestyle,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  tomli,
}:

buildPythonPackage rec {
  pname = "autopep8";
  version = "2.0.4-unstable-2023-10-27";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hhatto";
    repo = "autopep8";
    rev = "af7399d90926f2fe99a71f15197a08fa197f73a1";
    hash = "sha256-psGl9rXxTQGHyXf1VskJ/I/goVH5hRRP5bUXQdaT/8M=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ pycodestyle ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
  ];

  env.LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    changelog = "https://github.com/hhatto/autopep8/releases/tag/v${version}";
    description = "A tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = "https://github.com/hhatto/autopep8";
    license = licenses.mit;
    mainProgram = "autopep8";
    maintainers = with maintainers; [ bjornfor ];
  };
}
