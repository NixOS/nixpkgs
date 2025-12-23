{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fzf,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyfzf";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nk412";
    repo = "pyfzf";
    rev = version;
    hash = "sha256-w+ZjQGFd/lR2TiTHc2uQSJXORmzJJZXsr9BO4PIw/Co=";
  };

  propagatedBuildInputs = [ fzf ];

  pythonImportsCheck = [ "pyfzf" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Wrapper for fzf";
    homepage = "https://github.com/nk412/pyfzf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
