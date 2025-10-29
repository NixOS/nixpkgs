{
  lib,
  blockdiag,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "nwdiag";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = "nwdiag";
    tag = version;
    hash = "sha256-uKrdkXpL5YBr953sRsHknYg+2/WwrZmyDf8BMA2+0tU=";
  };

  patches = [ ./fix_test_generate.patch ];

  build-system = [ setuptools ];

  dependencies = [ blockdiag ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/nwdiag/tests/" ];

  disabledTests = [
    # AttributeError: 'TestRstDirectives' object has no attribute 'assertRegexpMatches'
    "svg"
    "noviewbox"
  ];

  pythonImportsCheck = [ "nwdiag" ];

  meta = with lib; {
    description = "Generate network-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    changelog = "https://github.com/blockdiag/nwdiag/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
    mainProgram = "rackdiag";
    platforms = platforms.unix;
  };
}
