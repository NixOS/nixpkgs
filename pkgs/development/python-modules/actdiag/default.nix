{
  lib,
  blockdiag,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "actdiag";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = "actdiag";
    tag = version;
    hash = "sha256-WmprkHOgvlsOIg8H77P7fzEqxGnj6xaL7Df7urRkg3o=";
  };

  patches = [ ./fix_test_generate.patch ];

  build-system = [ setuptools ];

  propagatedBuildInputs = [ blockdiag ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "src/actdiag/tests/" ];

  disabledTests = [
    # AttributeError: 'TestRstDirectives' object has no attribute 'assertRegexpMatches'
    "svg"
    "noviewbox"
  ];

  pythonImportsCheck = [ "actdiag" ];

  meta = {
    description = "Generate activity-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    changelog = "https://github.com/blockdiag/actdiag/blob/${version}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bjornfor ];
    mainProgram = "actdiag";
    platforms = lib.platforms.unix;
  };
}
