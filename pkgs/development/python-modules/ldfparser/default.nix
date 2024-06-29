{
  lib,
  bitstruct,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  jsonschema,
  lark,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ldfparser";
  version = "0.25.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "c4deszes";
    repo = "ldfparser";
    rev = "refs/tags/v${version}";
    hash = "sha256-SZ9mWV5PjkQ2OiScPSMrunkKQWmuYW2lB2JvpTGNbY4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bitstruct
    jinja2
    lark
  ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ldfparser" ];

  disabledTestPaths = [
    # We don't care about benchmarks
    "tests/test_performance.py"
  ];

  meta = with lib; {
    description = "LIN Description File parser written in Python";
    homepage = "https://github.com/c4deszes/ldfparser";
    changelog = "https://github.com/c4deszes/ldfparser/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ldfparser";
  };
}
