{
  buildPythonPackage,
  lib,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # checks
  mock,
  pytestCheckHook,
  sh,
  coverage,
  docopt,
  requests,
  git,
  responses,
}:

buildPythonPackage rec {
  pname = "coveralls";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TheKevJames";
    repo = "coveralls-python";
    rev = "refs/tags/${version}";
    hash = "sha256-1MjP99NykWNDyzWwZopLAzZ93vGX1mXEU+m+zvOBIZA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    coverage
    docopt
    requests
  ];

  nativeCheckInputs = [
    mock
    sh
    pytestCheckHook
    responses
    git
  ];

  preCheck = ''
    export PATH=${coverage}/bin:$PATH
  '';

  disabledTests = [
    # requires .git in checkout
    "test_git"
    # try to run unwrapped python
    "test_5"
    "test_7"
    "test_11"
  ];

  meta = {
    description = "Show coverage stats online via coveralls.io";
    mainProgram = "coveralls";
    homepage = "https://github.com/coveralls-clients/coveralls-python";
    license = lib.licenses.mit;
  };
}
