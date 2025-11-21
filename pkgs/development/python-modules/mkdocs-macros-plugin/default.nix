{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  hjson,
  jinja2,
  mkdocs,
  packaging,
  pathspec,
  python-dateutil,
  pyyaml,
  termcolor,
  super-collections,
  mkdocs-test,
  mkdocs-material,
  mkdocs-macros-test,
}:

buildPythonPackage rec {
  pname = "mkdocs-macros-plugin";
  version = "1.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fralau";
    repo = "mkdocs-macros-plugin";
    tag = "v${version}";
    hash = "sha256-bL7oWWDoF+zH34XSwFY2H9op/97zO43HS+oO6lNFEr4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    hjson
    jinja2
    mkdocs
    packaging
    pathspec
    python-dateutil
    pyyaml
    termcolor
    super-collections
  ];

  pythonImportsCheck = [
    "mkdocs_macros"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mkdocs-test
    mkdocs-material
    mkdocs-macros-test
  ];

  disabledTestPaths = [
    # we do not have brew and mkdocs-d2-plugin is also not packaged in nixpkgs,
    "test/plugin_d2/test_t2.py"
  ];

  meta = {
    description = "Create richer and more beautiful pages in MkDocs, by using variables and calls to macros in the markdown code";
    homepage = "https://github.com/fralau/mkdocs-macros-plugin";
    changelog = "https://github.com/fralau/mkdocs-macros-plugin/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tljuniper ];
  };
}
