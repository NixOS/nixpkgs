{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mkdocs,
  properdocs,
  pytestCheckHook,
  testfixtures,
  pytest-golden,
}:

buildPythonPackage (finalAttrs: {
  pname = "mkdocs-literate-nav";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oprypin";
    repo = "mkdocs-literate-nav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YsWZhMGmOaZjJpQSPddW3TlBCieefQ42Tne85fdP1t0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    mkdocs
    properdocs
  ];

  pythonImportsCheck = [
    "mkdocs_literate_nav"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    testfixtures
    pytest-golden
  ];

  meta = {
    description = "MkDocs plugin to specify the navigation in Markdown instead of YAML";
    homepage = "https://github.com/oprypin/mkdocs-literate-nav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
