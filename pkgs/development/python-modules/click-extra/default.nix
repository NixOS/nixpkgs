{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  pytestCheckHook,
  hjson,
  jsonschema,
  myst-parser,
  pygments,
  pytest-httpserver,
  pyyaml,
  requests,
  sphinx,
  tomlkit,
  xmltodict,
  uv-build,
  boltons,
  click,
  cloup,
  deepmerge,
  extra-platforms,
  tabulate,
  wcmatch,
  wcwidth,
}:

buildPythonPackage (finalAttrs: {
  pname = "click-extra";
  version = "8.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kdeldycke";
    repo = "click-extra";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h+FWG6YHWCDDkQ0CxX0h9F8yD2z8H5bMtRAL4Y5WQkQ=";
  };

  build-system = [ uv-build ];

  # wcwidth backs the ``tabulate[widechars]`` extra pinned in pyproject.toml
  # and is also a direct runtime dependency since 8.4.
  dependencies = [
    boltons
    click
    cloup
    deepmerge
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
    pygments
    pytest-httpserver
    pyyaml
    requests
    sphinx
    tomlkit
    xmltodict
  ];

  # Tests marked ``network`` make HTTPS requests; the build sandbox has no
  # system TLS CA bundle.
  disabledTestMarks = [ "network" ];

  # The configuration tests are served over HTTP by a local pytest-httpserver
  # binding to ``localhost``. The Darwin build sandbox cuts the build off from
  # the resolver, so that bind fails there with a ``gaierror`` unless local
  # networking is allowed.
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
