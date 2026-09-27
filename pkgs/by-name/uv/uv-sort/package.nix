{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "uv-sort";
  version = "0.8.0";
  pyproject = true;

  # Build from GitHub does not work. Use fetchPypi instead of fetchFromGitHub.
  # See https://github.com/NixOS/nixpkgs/pull/388382#issuecomment-2708857805
  src = fetchPypi {
    pname = "uv_sort";
    inherit (finalAttrs) version;
    hash = "sha256-GXR9aN2s0ryFl2KMED9ggUPt3ddXfOrzsdUNkyhsT6E=";
  };

  build-system = with python3Packages; [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    tomlrt
    typer
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  # tomlrt 2.2.0 changed indentation behavior for array elements after standalone
  # comments, causing 3 parametrized cases of test_sort_array to fail.
  disabledTests = [
    "test_sort_array"
  ];

  meta = {
    description = "Sort uv's dependencies alphabetically";
    homepage = "https://github.com/ninoseki/uv-sort";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "uv-sort";
  };
})
