{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  ujson,
}:

buildPythonPackage rec {
  pname = "python-lsp-jsonrpc";
  version = "1.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-jsonrpc";
    tag = "v${version}";
    hash = "sha256-5WN/31e6WCgXVzevMuQbNjyo/2jjWDF+m48nrLKS+64=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ ujson ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pylsp_jsonrpc" ];

  meta = with lib; {
    description = "Python server implementation of the JSON RPC 2.0 protocol";
    homepage = "https://github.com/python-lsp/python-lsp-jsonrpc";
    changelog = "https://github.com/python-lsp/python-lsp-jsonrpc/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
