{
  lib,
  blockdiag,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nwdiag";
  version = "3.0.0";
  pyproject = true;

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

  meta = {
    description = "Generate network-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    changelog = "https://github.com/blockdiag/nwdiag/blob/${version}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bjornfor ];
    mainProgram = "rackdiag";
    platforms = lib.platforms.unix;
  };
}
