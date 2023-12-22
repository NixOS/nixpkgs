{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, black
, python-lsp-server
, toml
}:

buildPythonPackage rec {
  pname = "python-lsp-black";
  version = "2.0.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-black";
    rev = "refs/tags/v${version}";
    hash = "sha256-nV6mePSWzfPW2RwXg/mxgzfT9wD95mmTuPnPEro1kEY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ black python-lsp-server toml ];

  meta = with lib; {
    homepage = "https://github.com/python-lsp/python-lsp-black";
    description = "Black plugin for the Python LSP Server";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
