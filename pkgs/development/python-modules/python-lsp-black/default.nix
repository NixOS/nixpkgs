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
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = "python-lsp-black";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-16HjNB0VfrXLyVa+u5HaFNjq/ER2yXIWokMFsPgejr8=";
=======
    rev = "v${version}";
    hash = "sha256-qNA6Bj1VI0YEtRuvcMQZGWakQNNrJ2PqhozrLmQHPAg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
