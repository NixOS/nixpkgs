{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pygments
}:

buildPythonPackage rec {
  pname = "markdown2";
  version = "2.4.8";

  # PyPI does not contain tests, so using GitHub instead.
  src = fetchFromGitHub {
    owner = "trentm";
    repo = "python-markdown2";
    rev = version;
    hash = "sha256-0T3HcfjEApEEWtNZGZcta85dY9d/0mSyRBlrqBQEQwk=";
  };

  nativeCheckInputs = [ pygments ];

  checkPhase = ''
    runHook preCheck

    pushd test
    ${python.interpreter} ./test.py -- -knownfailure
    popd  # test

    runHook postCheck
  '';

  meta = with lib; {
    changelog = "https://github.com/trentm/python-markdown2/blob/${src.rev}/CHANGES.md";
    description = "A fast and complete Python implementation of Markdown";
    homepage =  "https://github.com/trentm/python-markdown2";
    license = licenses.mit;
    maintainers = with maintainers; [ hbunke ];
  };
}
