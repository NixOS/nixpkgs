{
  lib,
  buildPythonPackage,
  cachecontrol,
  feedparser,
  fetchFromGitHub,
  gitpython,
  jsonfeed,
  mkdocs,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  validator-collection,
}:

buildPythonPackage rec {
  pname = "mkdocs-rss-plugin";
  version = "1.17.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Guts";
    repo = "mkdocs-rss-plugin";
    tag = version;
    hash = "sha256-wgR0uwme7fXNZHx7xdm0HNfXG6qT4qpTJgR2SaXDel4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cachecontrol
    gitpython
    mkdocs
  ]
  ++ cachecontrol.optional-dependencies.filecache;

  nativeCheckInputs = [
    feedparser
    jsonfeed
    pytest-cov-stub
    pytestCheckHook
    validator-collection
  ];

  pythonImportsCheck = [ "mkdocs_rss_plugin" ];

  disabledTests = [
    # Tests require network access
    "test_plugin_config_through_mkdocs"
    "test_remote_image"
    # Configuration error
    "test_plugin_config_blog_enabled"
    "test_plugin_config_social_cards_enabled_but_integration_disabled"
    "test_plugin_config_theme_material"
    "test_simple_build"
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
    changelog = "https://github.com/Guts/mkdocs-rss-plugin/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
