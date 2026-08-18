{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  glibcLocales,
  pycodestyle,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "autopep8";
  version = "2.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hhatto";
    repo = "autopep8";
    tag = "v${version}";
    hash = "sha256-9OJ5XbzpHMHsFjf5oVyHjn5zqmAxRuSItWP4sQx8jD4=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ pycodestyle ];

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
  ];

  env.LC_ALL = "en_US.UTF-8";

  meta = {
    changelog = "https://github.com/hhatto/autopep8/releases/tag/v${version}";
    description = "Tool that automatically formats Python code to conform to the PEP 8 style guide";
    homepage = "https://github.com/hhatto/autopep8";
    license = lib.licenses.mit;
    mainProgram = "autopep8";
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
