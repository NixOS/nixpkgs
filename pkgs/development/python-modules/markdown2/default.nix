{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, python
, pygments
}:

buildPythonPackage rec {
  pname = "markdown2";
  version = "2.4.3";

  # PyPI does not contain tests, so using GitHub instead.
  src = fetchFromGitHub {
    owner = "trentm";
    repo = "python-markdown2";
    rev = version;
    sha256 = "sha256-zNZ7/dDZbPIwcxSLvf8u5oaAgHLrZ6kk4vXNPUuZs/4=";
  };

  patches = [
    (fetchpatch {
      name = "SNYK-PYTHON-MARKDOWN2-2606985-xss.patch";  # no CVE (yet?)
      url = "https://github.com/trentm/python-markdown2/commit/5898fcc1090ef7cd7783fa1422cc0e53cbca9d1b.patch";
      sha256 = "sha256-M6kKxjHVC3O0BvDeEF4swzfpFsDO/LU9IHvfjK4hznA=";
    })
  ];

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
