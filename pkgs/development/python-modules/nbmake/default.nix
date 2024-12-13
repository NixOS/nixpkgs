{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  setuptools,
  wheel,
  ipykernel,
  nbclient,
  nbformat,
  pygments,
  pytest,
  pyyaml,
  pytest-xdist,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "nbmake";
  version = "1.5.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "treebeardtech";
    repo = "nbmake";
    rev = "refs/tags/v${version}";
    hash = "sha256-OzjqpipFb5COhqc//Sg6OU65ShPrYe/KtxifToEXveg=";
  };

  build-system = [
    poetry-core
    setuptools
    wheel
  ];

  dependencies = [
    ipykernel
    nbclient
    nbformat
    pygments
    pytest
    pyyaml
  ];

  pythonRelaxDeps = [ "nbclient" ];

  pythonImportsCheck = [ "nbmake" ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    typing-extensions
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Pytest plugin for testing notebooks";
    homepage = "https://github.com/treebeardtech/nbmake";
    changelog = "https://github.com/treebeardtech/nbmake/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
