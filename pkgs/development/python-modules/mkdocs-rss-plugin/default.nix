{
  lib,
  buildPythonPackage,
  feedparser,
  fetchFromGitHub,
  gitpython,
  jsonfeed,
  mkdocs,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  validator-collection,
}:

buildPythonPackage rec {
  pname = "mkdocs-rss-plugin";
  version = "1.13.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Guts";
    repo = "mkdocs-rss-plugin";
    rev = "refs/tags/${version}";
    hash = "sha256-CUgUiLVrKI+i9F+Bc0a4r2jaW7e65JHGxOi8xGhZxWI=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  build-system = [ setuptools ];

  dependencies = [
    gitpython
    mkdocs
  ];

  nativeCheckInputs = [
    feedparser
    jsonfeed
    pytestCheckHook
    validator-collection
  ];

  pythonImportsCheck = [ "mkdocs_rss_plugin" ];

  disabledTests = [
    # Tests require network access
    "test_plugin_config_through_mkdocs"
    "test_remote_image_ok"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_integrations_material_social_cards.py"
    "tests/test_build_no_git.py"
    "tests/test_build.py"
  ];

  meta = with lib; {
    description = "MkDocs plugin to generate a RSS feeds for created and updated pages, using git log and YAML frontmatter";
    homepage = "https://github.com/Guts/mkdocs-rss-plugin";
    changelog = "https://github.com/Guts/mkdocs-rss-plugin/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
