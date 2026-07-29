{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  pythonOlder,
  pytestCheckHook,
  hjson,
  jsonschema,
  myst-parser,
  packaging,
  ps,
  pygments,
  pytest-httpserver,
  pyyaml,
  requests,
  sphinx,
  tomlrt,
  uv-build,
  click,
  cloup,
  extra-platforms,
  tabulate,
  wcmatch,
  wcwidth,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-extra";
  version = "10.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kdeldycke";
    repo = "click-extra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H5KNfhl4DtAkoe0Yo9F158m7ivnCU0B6t7Ngm8Wxtbk=";
  };

  build-system = [ uv-build ];

  # wcwidth backs the ``tabulate[widechars]`` extra pinned in pyproject.toml
  # and is also a direct runtime dependency since 8.4.
  dependencies = [
    click
    cloup
    extra-platforms
    tabulate
    wcmatch
    wcwidth
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # Optional libraries imported at module level by the test files.
    gitMinimal
    hjson
    jsonschema
    myst-parser
    packaging
    pygments
    pytest-httpserver
    pyyaml
    requests
    sphinx
    # The `toml` extra, which the TOML rendering and configuration export tests
    # call into.
    tomlrt
    # Outside Linux, click-extra reads the process table with `ps`, which the
    # build environment lacks. Without it, the process-group kill tests find no
    # descendant to stop.
    ps
  ];

  # Tests marked ``network`` make HTTPS requests; the build sandbox has no
  # system TLS CA bundle.
  disabledTestMarks = [ "network" ];

  # nixpkgs ships myst-parser 5.1.0, below the 5.2 floor of the `sphinx` extra.
  # These cases test the `content_offset` fix of 5.2.0, and fail one line off
  # on 5.1.0. Drop them once nixpkgs ships myst-parser 5.2.0 or newer.
  disabledTests = [
    "test_directive_variable_conflict and MYST"
    "test_generated_block_is_attributed_to_the_directive_body and body-ending-on-blank-lines-MYST"
  ]
  ++ lib.optionals (pythonOlder "3.14") [
    # cloup 4.0.0 imports `importlib.metadata` at module scope. Below Python
    # 3.14, that import also loads `tempfile` through `importlib.abc`, and this
    # test forbids `tempfile` at startup. Drop it once nixpkgs ships a cloup
    # above 4.0.0, which no longer makes that import.
    "test_no_heavy_dependency_ballast_on_startup"
  ];

  # The configuration tests are served over HTTP by a local pytest-httpserver.
  # It bound to ``localhost`` until 8.9.0 moved it to ``127.0.0.1``, which drops
  # the name lookup the Darwin build sandbox refuses (a ``gaierror``). Only that
  # lookup was ever proven to fail: whether the sandbox also gates the loopback
  # socket itself is untested, so the flag stays until a build without it comes
  # back green.
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "click_extra" ];

  meta = {
    description = "Drop-in replacement for Click to build colorful CLI";
    homepage = "https://github.com/kdeldycke/click-extra";
    changelog = "https://github.com/kdeldycke/click-extra/blob/v${finalAttrs.version}/changelog.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kdeldycke ];
  };
})
