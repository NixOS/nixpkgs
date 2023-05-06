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
  version = "1.2.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-black";
    rev = "v${version}";
    hash = "sha256-qNA6Bj1VI0YEtRuvcMQZGWakQNNrJ2PqhozrLmQHPAg=";
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
