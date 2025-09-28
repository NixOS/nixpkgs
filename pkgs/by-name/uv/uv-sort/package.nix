{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "uv-sort";
  version = "0.6.1";
  pyproject = true;

  # Build from GitHub does not work. Use fetchPypi instead of fetchFromGitHub.
  # See https://github.com/NixOS/nixpkgs/pull/388382#issuecomment-2708857805
  src = fetchPypi {
    pname = "uv_sort";
    inherit version;
    hash = "sha256-ovOCiu22ClSheWDsPBAx5s+LcR5jIQFqb1Dm0wpEKGU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"packaging~=24.1"' '"packaging"'
  '';

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
