{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flake8,
  python-lsp-server,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyls-flake8";
  version = "0.4.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "emanspeaks";
    repo = "pyls-flake8";
    rev = "v{version}";
    sha256 = "14wkmwh8mqr826vdzxhvhdwrnx2akzmnbv3ar391qs4imwqfjx3l";
  };

  propagatedBuildInputs = [
    flake8
    python-lsp-server
  ];

  meta = with lib; {
    homepage = "https://github.com/emanspeaks/pyls-flake8";
    description = "Flake8 plugin for the Python LSP Server";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
