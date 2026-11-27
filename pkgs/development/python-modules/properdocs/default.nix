{
  lib,
  babel,
  buildPythonPackage,
  click,
  colorama,
  fetchFromGitHub,
  ghp-import,
  hatchling,
  importlib-metadata,
  jinja2,
  markdown,
  markupsafe,
  mock,
  nix-update-script,
  packaging,
  pathspec,
  platformdirs,
  pyyaml-env-tag,
  pyyaml,
  pytestCheckHook,
  watchdog,
}:

buildPythonPackage (finalAttrs: {
  pname = "properdocs";
  version = "1.6.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProperDocs";
    repo = "properdocs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ACEgR9oNMPEDMLxeSJhNO7dJZBpTOiusfpE7XaXuztE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    colorama
    ghp-import
    importlib-metadata
    jinja2
    markdown
    markupsafe
    packaging
    pathspec
    platformdirs
    pyyaml
    pyyaml-env-tag
    watchdog
  ];

  optional-dependencies = {
    i18n = [ babel ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pytestFlags = [ "--override-ini=python_files=*tests.py" ];

  enabledTestPaths = [ "properdocs" ];

  disabledTestPaths = [
    # Issue with pytest
    "properdocs/tests/livereload_tests.py"
    # Missing dependencies
    "properdocs/tests/build_tests.py"
    "properdocs/tests/theme_tests.py"
    "properdocs/tests/structure/nav_tests.py"
    "properdocs/tests/structure/page_tests.py"
  ];

  disabledTests = [
    # Require mkdocs readthedocs themes
    "test_build_theme"
    "test_gh_deploy_theme"
    "test_serve_theme"
    "test_load_default_file"
    "test_load_default_file_prefer_yml"
    "test_load_default_file_with_yaml"
    "test_load_from_file"
    "test_load_from_file_with_relative_paths"
    "test_load_from_open_file"
    "test_post_validation_locale"
    "test_post_validation_locale_invalid_type"
    "test_post_validation_locale_none"
    "test_theme_as_complex_config"
    "test_theme_as_simple_config"
    "test_theme_as_string"
    "test_theme_default"
    "test_uninstalled_theme_as_config"
    "test_uninstalled_theme_as_string"
    "test_plugin_config_enabled_for_any_plugin"
    "test_plugin_config_enabled_for_plugin_with_setting"
    "test_plugin_config_with"
    "test_config_option"
    "test_error_on_pages"
    "test_missing_theme"
    "test_deploy"
    "test_deploy_no_cname"
    "test_deploy_hostname"
    "test_deploy_ignore_version_default"
    "test_deploy_ignore_version"
    "test_deploy_error"
    "test_run_build_error_event"
    "test_create_search_index"
    "test_event_on_config_defaults"
    "test_theme"
    "test_event_on_config"
    "test_event_on_post"
    "test_generated_file_constructor"
    "test_get_files"
    "test_get_files"
    "test_search_indexing"
    "test_script_tag"
    "test_get_themes"
  ];

  pythonImportsCheck = [ "properdocs" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Static site generator";
    homepage = "https://github.com/ProperDocs/properdocs";
    changelog = "https://github.com/ProperDocs/properdocs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "properdocs";
  };
})
