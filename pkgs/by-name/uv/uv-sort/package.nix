{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "uv-sort";
  version = "0.5.1";
  pyproject = true;

  # Build from GitHub does not work. Use fetchPypi instead of fetchFromGitHub.
  # See https://github.com/NixOS/nixpkgs/pull/388382#issuecomment-2708857805
  src = fetchPypi {
    pname = "uv_sort";
    inherit version;
    hash = "sha256-d0mI3BQQaoG5pPnqBqyAI2LQffkS9fxX+itD9UEL050=";
  };

  build-system = with python3Packages; [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    packaging
    tomlkit
    typer
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = {
    description = "Sort uv's dependencies alphabetically";
    homepage = "https://github.com/ninoseki/uv-sort";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "uv-sort";
  };
}
