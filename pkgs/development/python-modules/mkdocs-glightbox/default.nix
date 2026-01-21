{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  selectolax,
  pytestCheckHook,
  pytest-click,
  pytest-timeout,
  mkdocs-material,
}:

buildPythonPackage rec {
  pname = "mkdocs-glightbox";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "blueswen";
    repo = "mkdocs-glightbox";
    tag = "v${version}";
    hash = "sha256-6HkBeZHBLR3HqWh3WjjCqxR85nQuQqq9+7UwbXOZHRk=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    selectolax
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-click
    pytest-timeout
    mkdocs-material
  ];

  disabledTests = [
    # Checks compatible with material privacy plugin, which is currently not packaged in nixpkgs.
    "privacy"
  ];

  disabledTestPaths = [
    # dont execute benchmarks on hydra
    "tests/test_perf.py"
  ];

  pythonImportsCheck = [
    "mkdocs_glightbox"
  ];

  meta = {
    description = "MkDocs plugin supports image lightbox (zoom effect) with GLightbox";
    homepage = "https://github.com/blueswen/mkdocs-glightbox";
    changelog = "https://github.com/blueswen/mkdocs-glightbox/blob/v${version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcel ];
  };
}
