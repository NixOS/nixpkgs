{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-httpserver,
  pygments,
  pyyaml,
  hjson,
  tomlkit,
  xmltodict,
  uv-build,
  boltons,
  click,
  cloup,
  deepmerge,
  extra-platforms,
  requests,
  tabulate,
  wcmatch,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-extra";
  version = "7.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kdeldycke";
    repo = "click-extra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hof1SFh8XXBoQ9Pr4qI/7jNlBDMpUi7+qs1QcT042tY=";
  };

  build-system = [ uv-build ];

  dependencies = [
    boltons
    click
    cloup
    deepmerge
    extra-platforms
    requests
    tabulate
    wcmatch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # Optional libraries imported at module-level by various test files:
    # ``tests/test_table.py`` needs hjson, tomlkit, xmltodict and yaml
    # (the ``[hjson]``, ``[toml]``, ``[xml]`` and ``[yaml]`` extras
    # declared in pyproject.toml); ``tests/test_pygments.py`` needs
    # pygments; ``tests/test_config.py`` uses the ``httpserver`` fixture
    # from pytest-httpserver to test remote configuration loading.
    hjson
    pygments
    pytest-httpserver
    pyyaml
    tomlkit
    xmltodict
  ];

  # ``-m "not network"`` skips ``test_ansi_lexers_candidates`` and other
  # network-tagged tests; the build sandbox has no system TLS CA bundle.
  pytestFlagsArray = [
    "-m"
    "not network"
  ];

  disabledTestPaths = [
    # tests/sphinx requires the Sphinx ecosystem (myst-parser, furo,
    # etc.) not packaged in nixpkgs.
    "tests/sphinx"
    # tests/mkdocs requires mkdocs-click.
    "tests/mkdocs"
  ];

  disabledTests = [
    # The four integration tests below assert against debug output that
    # should not include the test sandbox's ``$HOME``; click-extra logs
    # the search pattern using the runtime environment HOME instead of
    # the test fixture's ``tmp_path``.
    "test_integrated_color_option"
    "test_required_command"
    "test_unset_conf_debug_message"
    "test_integrated_verbosity_options"
  ];

  pythonImportsCheck = [ "click_extra" ];

  meta = {
    description = "Drop-in replacement for Click to build colorful CLI";
    homepage = "https://github.com/kdeldycke/click-extra";
    changelog = "https://github.com/kdeldycke/click-extra/blob/v${finalAttrs.version}/changelog.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kdeldycke ];
  };
})
