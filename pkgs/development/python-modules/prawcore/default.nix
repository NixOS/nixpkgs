{
  lib,
  betamax,
  betamax-matchers,
  betamax-serializers,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-toolbelt,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "prawcore";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "prawcore";
    tag = "v${version}";
    hash = "sha256-tECZRx6VgyiJDKHvj4Rf1sknFqUhz3sDFEsAMOeB7/g=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    testfixtures
    mock
    betamax
    betamax-serializers
    betamax-matchers
    requests-toolbelt
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests requiring network
    "tests/integration"
  ];

  pythonImportsCheck = [ "prawcore" ];

  meta = with lib; {
    description = "Low-level communication layer for PRAW";
    homepage = "https://praw.readthedocs.org/";
    changelog = "https://github.com/praw-dev/prawcore/blob/v${version}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
