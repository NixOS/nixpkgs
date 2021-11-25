{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, mypy
, pytestCheckHook
, python-lsp-server
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylsp-mypy";
  version = "0.5.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Richardk2n";
    repo = "pylsp-mypy";
    rev = version;
    sha256 = "1d119csj1k5m9j0f7wdvpvnd02h548css6ybxqah92nk2v0rjscr";
  };

  checkInputs = [ pytestCheckHook mock ];

  propagatedBuildInputs = [ mypy python-lsp-server ];

  meta = with lib; {
    homepage = "https://github.com/Richardk2n/pylsp-mypy";
    description = "Mypy plugin for the Python LSP Server";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
