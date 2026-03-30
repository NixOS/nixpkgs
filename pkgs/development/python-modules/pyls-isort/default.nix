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
    sha256 = "0xba0aiyjfdi9swjzxk26l94dwlwvn17kkfjfscxl8gvspzsn057";
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
