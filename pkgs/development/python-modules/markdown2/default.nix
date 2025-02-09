{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pygments
, pythonOlder
, wavedrom
}:

buildPythonPackage rec {
  pname = "markdown2";
  version = "2.4.10";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  # PyPI does not contain tests, so using GitHub instead.
  src = fetchFromGitHub {
    owner = "trentm";
    repo = "python-markdown2";
    rev = version;
    hash = "sha256-1Vs2OMQm/XBOEefV6W58X5hap91aTNuTx8UFf0285uk=";
  };

  nativeCheckInputs = [ pygments ];

  checkPhase = ''
    runHook preCheck

    pushd test
    ${python.interpreter} ./test.py -- -knownfailure
    popd  # test

    runHook postCheck
  '';

  passthru.optional-dependencies = {
    code_syntax_highlighting = [
      pygments
    ];
    wavedrom = [
      wavedrom
    ];
    all = lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") passthru.optional-dependencies));
  };

  meta = with lib; {
    changelog = "https://github.com/trentm/python-markdown2/blob/${src.rev}/CHANGES.md";
    description = "A fast and complete Python implementation of Markdown";
    homepage =  "https://github.com/trentm/python-markdown2";
    license = licenses.mit;
    maintainers = with maintainers; [ hbunke ];
  };
}
