{ lib, buildPythonPackage, fetchFromGitHub, python, pygments }:

buildPythonPackage rec {
  pname = "markdown2";
  version = "2.4.0";

  # PyPI does not contain tests, so using GitHub instead.
  src = fetchFromGitHub {
    owner = "trentm";
    repo = "python-markdown2";
    rev = version;
    sha256 = "sha256:03qmf087phpj0h9hx111k4r5pkm48dhb61mqhp1v75gd09k0z79z";
  };

  checkInputs = [ pygments ];

  checkPhase = ''
    ${python.interpreter} ./test/test.py
  '';

  meta = with lib; {
    description = "A fast and complete Python implementation of Markdown";
    homepage =  "https://github.com/trentm/python-markdown2";
    license = licenses.mit;
    maintainers = with maintainers; [ hbunke ];
  };
}
