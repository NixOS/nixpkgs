{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mkdocs,
  pytestCheckHook,
  mechanicalsoup,
  testfixtures,
  pytest-golden,
  mkdocs-material,
}:

buildPythonPackage rec {
  pname = "mkdocs-section-index";
  version = "0.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oprypin";
    repo = "mkdocs-section-index";
    tag = "v${version}";
    hash = "sha256-cw/a17xliK68vStC20f+IHI3nQl1/s/lIIj1tyQJti0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    mkdocs
  ];

  pythonImportsCheck = [
    "mkdocs_section_index"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mechanicalsoup
    testfixtures
    pytest-golden
    mkdocs-material
  ];

  meta = {
    description = "MkDocs plugin to allow clickable sections that lead to an index page";
    homepage = "https://github.com/oprypin/mkdocs-section-index";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
