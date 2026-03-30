{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "immutables";
  version = "0.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MagicStack";
    repo = "immutables";
    tag = "v${version}";
    hash = "sha256-wZuCZEVXzycqA/h27RIe59e2QQALem8mfb3EdjwQr9w=";
  };

  postPatch = ''
    rm tests/conftest.py
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Version mismatch
    "testMypyImmu"
  ];

  disabledTestPaths = [
    # avoid dependency on mypy
    "tests/test_mypy.py"
  ];

  pythonImportsCheck = [ "immutables" ];

  meta = {
    description = "Immutable mapping type";
    homepage = "https://github.com/MagicStack/immutables";
    changelog = "https://github.com/MagicStack/immutables/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
  };
}
