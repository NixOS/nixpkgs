{
  lib,
  buildPythonPackage,
  babel,
  commonmark,
  fetchFromGitHub,
  htmltools,
  importlib-metadata,
  importlib-resources,
  numpy,
  pillow,
  selenium,
  setuptools,
  setuptools-scm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "great-tables";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "posit-dev";
    repo = "great-tables";
    rev = "refs/tags/v${version}";
    hash = "sha256-FLRuSqGKGKFbhj9t+iOm+E5oimkEzmmX3lqHYuJ6FU8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    babel
    commonmark
    htmltools
    importlib-metadata
    importlib-resources
    numpy
    typing-extensions
  ];

  passthru.optional-dependencies = {
    extra = [
      pillow
      selenium
    ];
  };

  # need high version of polars
  doCheck = false;

  pythonImportsCheck = [ "great_tables" ];

  meta = {
    description = "Make awesome display tables using Python";
    homepage = "https://github.com/posit-dev/great-tables";
    changelog = "https://github.com/posit-dev/great-tables/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
