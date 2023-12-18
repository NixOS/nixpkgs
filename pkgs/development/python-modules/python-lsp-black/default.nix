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
  version = "1.3.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-black";
    rev = "refs/tags/v${version}";
    hash = "sha256-16HjNB0VfrXLyVa+u5HaFNjq/ER2yXIWokMFsPgejr8=";
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
