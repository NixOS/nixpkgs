{ lib, buildPythonPackage, fetchFromGitHub
, python-language-server, isort
}:

buildPythonPackage rec {
  pname = "pyls-isort";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "paradoxxxzero";
    repo = "pyls-isort";
    rev = version;
    sha256 = "0mf8c6dw5lsj9np20p0vrhr1yfycq2awjk2pil28l579xj9nr0dc";
  };

  # no tests
  doCheck = false;

  propagatedBuildInputs = [
    isort python-language-server
  ];

  meta = with lib; {
    homepage = https://github.com/paradoxxxzero/pyls-isort;
    description = "Isort plugin for python-language-server";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
