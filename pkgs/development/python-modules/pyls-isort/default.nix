{ lib, buildPythonPackage, fetchFromGitHub
, python-lsp-server, isort
}:

buildPythonPackage rec {
  pname = "pyls-isort";
  version = "0.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "pyls-isort";
    rev = "v${version}";
    sha256 = "0xba0aiyjfdi9swjzxk26l94dwlwvn17kkfjfscxl8gvspzsn057";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pyls_isort" ];

  propagatedBuildInputs = [
    isort python-lsp-server
  ];

  meta = with lib; {
    homepage = "https://github.com/paradoxxxzero/pyls-isort";
    description = "Isort plugin for python-lsp-server";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
