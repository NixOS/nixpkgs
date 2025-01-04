{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sphinx-markdown-builder";
  version = "0.6.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "liran-funaro";
    repo = "sphinx-markdown-builder";
    rev = version;
    hash = "sha256-hrXuLfICiWVmC1HUypfhbW92YRmqzFY8nHVEWhTAJ6c=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    docutils
    sphinx
    tabulate
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      black
      bumpver
      coveralls
      flake8
      isort
      pip-tools
      pylint
      pytest
      pytest-cov
      sphinx
      sphinxcontrib-httpdomain
      sphinxcontrib-plantuml
    ];
  };

  pythonImportsCheck = [
    "sphinx_markdown_builder"
  ];

  meta = {
    description = "A Sphinx extension to add markdown generation support";
    homepage = "https://github.com/liran-funaro/sphinx-markdown-builder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "sphinx-markdown-builder";
  };
}
