{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  colorlog,
  importlab,
  online-judge-tools,
  pyyaml,
  setuptools,
  toml,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "online-judge-verify-helper";
  version = "5.6.0";
  pyproject = true;
  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "online-judge-tools";
    repo = "verification-helper";
    tag = "v${version}";
    hash = "sha256-sBR9/rf8vpDRbRD8HO2VNmxVckXPmPjUih7ogLRFaW8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorlog
    importlab
    online-judge-tools
    pyyaml
    setuptools
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # No additional dependencies or network access
  disabledTestPaths = [
    "tests/test_docs"
    "tests/test_python"
    "tests/test_rust"
    "tests/test_stats"
    "tests/test_verify"
  ];

  # No version check command, just ensure they run
  checkPhase = ''
    runHook preCheck
    export PATH=$out/bin:$PATH
    oj-verify --help > /dev/null
    oj-bundle --help > /dev/null
    runHook postCheck
  '';

  pythonImportsCheck = [
    "onlinejudge"
    "onlinejudge_bundle"
    "onlinejudge_verify"
    "onlinejudge_verify_resources"
  ];

  meta = {
    description = "Testing framework for snippet libraries used in competitive programming";
    mainProgram = "oj-verify";
    homepage = "https://github.com/online-judge-tools/verification-helper";
    changelog = "https://github.com/online-judge-tools/verification-helper/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toyboot4e ];
  };
}
