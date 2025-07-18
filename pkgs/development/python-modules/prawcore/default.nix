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
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "praw-dev";
    repo = "prawcore";
    tag = "v${version}";
    hash = "sha256-R1nFKypVTKfFQxJ3zSrxwb4Wwat5nARc5MF026qMMyQ=";
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
    changelog = "https://github.com/praw-dev/prawcore/blob/${src.tag}/CHANGES.rst";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
