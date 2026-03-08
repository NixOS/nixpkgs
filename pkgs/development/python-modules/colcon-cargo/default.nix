{
  lib,
  buildPythonPackage,
  colcon,
  cargo,
  fetchFromGitHub,
  scspell,
  setuptools,
  pytestCheckHook,
  rustfmt,
  toml,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "colcon-cargo";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "colcon";
    repo = "colcon-cargo";
    tag = version;
    hash = "sha256-jhc5mN4jnLk2zLj01sBm63acrku/FIexnIWCQ6GKDKA=";
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
