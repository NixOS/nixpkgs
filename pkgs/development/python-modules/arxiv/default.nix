{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  feedparser,
  pdoc,
  pip-audit,
  pytest,
  requests,
  ruff,
}:

buildPythonPackage rec {
  pname = "arxiv";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lukasschwab";
    repo = "arxiv.py";
    rev = version;
    hash = "sha256-Niu3N0QTVxucboQx1FQq1757Hjj1VVWeDZn7O7YtjWY=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    feedparser
    pdoc
    pip-audit
    pytest
    requests
    ruff
  ];

  pythonImportsCheck = [
    "arxiv"
  ];

  meta = {
    description = "Python wrapper for the arXiv API";
    homepage = "https://github.com/lukasschwab/arxiv.py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
