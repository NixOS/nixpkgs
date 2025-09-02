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

  # we do not have bew and mkdocs-d2-plugin is also not packaged in nixpkgs,
  # so we skip the assertion
  postPatch = ''
    substituteInPlace test/plugin_d2/test_t2.py \
      --replace-fail 'brew' 'false'
  '';

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
  ];

  disabledTests = [
    # was not able to get them running
    "test_pages"
    "test_strict"
  ];

  meta = {
    description = "Create richer and more beautiful pages in MkDocs, by using variables and calls to macros in the markdown code";
    homepage = "https://github.com/fralau/mkdocs-macros-plugin";
    changelog = "https://github.com/fralau/mkdocs-macros-plugin/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tljuniper ];
  };
}
