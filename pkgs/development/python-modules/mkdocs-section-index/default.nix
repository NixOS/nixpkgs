{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mkdocs,
  properdocs,
  pytestCheckHook,
  mechanicalsoup,
  testfixtures,
  pytest-golden,
  mkdocs-material,
}:

buildPythonPackage (finalAttrs: {
  pname = "mkdocs-section-index";
  version = "0.3.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oprypin";
    repo = "mkdocs-section-index";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gQ3hOEwds8isv96J3dp9iTPJ737z0z8R7Cgxa71tjXw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    mkdocs
    properdocs
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
})
