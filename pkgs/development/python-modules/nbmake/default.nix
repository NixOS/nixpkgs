{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  ipykernel,
  nbclient,
  nbformat,
  pygments,

  # tests
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "nbmake";
  version = "1.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "treebeardtech";
    repo = "nbmake";
    tag = "v${version}";
    hash = "sha256-Du2sxSl1a5ZVl7ueHWnkTTPtuMUlmALuOuSkoEFIQcE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    ipykernel
    nbclient
    nbformat
    pygments
  ];

  pythonRelaxDeps = [ "nbclient" ];

  pythonImportsCheck = [ "nbmake" ];

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # depends on pytest-xdist that is not added, as
    # tests are prone to race conditions under parallelism, they sometimes hang indefinitely
    # https://github.com/treebeardtech/nbmake/issues/129
    "test_when_parallel_passing_nbs_then_ok"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Pytest plugin for testing notebooks";
    homepage = "https://github.com/treebeardtech/nbmake";
    changelog = "https://github.com/treebeardtech/nbmake/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
