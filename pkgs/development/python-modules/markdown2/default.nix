{ lib, buildPythonPackage, fetchFromGitHub, python, pygments }:

buildPythonPackage rec {
  pname = "markdown2";
  version = "2.4.1";

  # PyPI does not contain tests, so using GitHub instead.
  src = fetchFromGitHub {
    owner = "trentm";
    repo = "python-markdown2";
    rev = version;
    sha256 = "0y7kh9jj8ys00qkfmmyqj63y21g7wn7yr715kj0j1nabs6xbp0y7";
  };

  checkInputs = [ pygments ];

  checkPhase = ''
    runHook preCheck

    pushd test
    ${python.interpreter} ./test.py -- -knownfailure
    popd  # test

    runHook postCheck
  '';

  meta = with lib; {
    description = "A fast and complete Python implementation of Markdown";
    homepage =  "https://github.com/trentm/python-markdown2";
    license = licenses.mit;
    maintainers = with maintainers; [ hbunke ];
  };
}
