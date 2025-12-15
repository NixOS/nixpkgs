{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  bluepy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "btlewrap";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ChristianKuehnel";
    repo = "btlewrap";
    tag = "v${version}";
    hash = "sha256-cjPj+Uw/L9kq/BbxlnOCJtaBcnf9VOJKN2NJ3cmKe6U=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    bluepy = [ bluepy ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Require optional dependencies or hardware
    "test/unit_tests/test_bluepy.py"
    "test/unit_tests/test_pygatt.py"
    "test/integration_tests/"
    "test/unit_tests/test_available_backends.py"
  ];

  pythonImportsCheck = [ "btlewrap" ];

  meta = {
    description = "Wrapper around different bluetooth low energy backends";
    homepage = "https://github.com/ChristianKuehnel/btlewrap";
    changelog = "https://github.com/ChristianKuehnel/btlewrap/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
