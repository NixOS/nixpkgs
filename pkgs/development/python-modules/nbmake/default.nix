{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pythonRelaxDepsHook,
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
  version = "1.5.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "treebeardtech";
    repo = "nbmake";
    rev = "refs/tags/v${version}";
    hash = "sha256-sX0YqyBchLlo0QPIpLvl11/gwoiZknG5rBDzmQKiXhs=";
  };

  build-system = [
    poetry-core
    pythonRelaxDepsHook
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

  meta = with lib; {
    description = "Pytest plugin for testing notebooks";
    homepage = "https://github.com/treebeardtech/nbmake";
    changelog = "https://github.com/treebeardtech/nbmake/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
