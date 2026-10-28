{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python-lsp-server,
  isort,
}:

buildPythonPackage rec {
  pname = "pyls-isort";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "pyls-isort";
    tag = "v${version}";
    hash = "sha256-pwCr/9X7IdqZdtLNeYLdnPJGEjVi9i+5TrE56aMCanU=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pyls_isort" ];

  build-system = [ setuptools ];

  dependencies = [
    isort
    python-lsp-server
  ];

  meta = {
    homepage = "https://github.com/paradoxxxzero/pyls-isort";
    description = "Isort plugin for python-lsp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
