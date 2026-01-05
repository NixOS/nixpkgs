{
  lib,
  buildPythonPackage,
  colcon,
  cargo,
  fetchFromGitHub,
  scspell,
  setuptools,
  pythonOlder,
  pytestCheckHook,
  rustfmt,
  toml,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "colcon-cargo";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-cargo";
    tag = version;
    hash = "sha256-Do8i/Z1nn8wsj0xzCQdSaaXoDf9N34SiMb/GIe4YOs4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colcon
    toml
  ];

  nativeCheckInputs = [
    cargo
    pytestCheckHook
    scspell
    rustfmt
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Skip the linter tests
    "test/test_flake8.py"
  ];

  pythonImportsCheck = [
    "colcon_cargo"
  ];

  meta = {
    description = "Extension for colcon-core to support Rust packages built with Cargo";
    homepage = "https://github.com/colcon/colcon-cargo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
  };
}
