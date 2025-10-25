{
  lib,
  stdenv,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-git-versioning,

  # dependencies
  choreographer,
  logistro,
  packaging,

  # tests
  async-timeout,
  hypothesis,
  numpy,
  pandas,
  plotly,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,

  # Circular dependency on plotly; needs bootstrapping
  withPlotly ? true,
}:

buildPythonPackage (finalAttrs: {
  pname = "kaleido";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "Kaleido";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BXZs+gSja9E327YqsutzutUaB1NwrMDOyB2LbW5y/lM=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/py";

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = [
    choreographer
    logistro
    packaging
  ];

  nativeCheckInputs = [
    async-timeout
    hypothesis
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.optionals withPlotly [
    numpy
    pandas
    plotly
  ];

  doCheck = withPlotly;

  # Rendering launches a browser that can't run in the macOS build sandbox
  # (see choreographer). Gated so it is only set when those checks run.
  __noChroot = stdenv.hostPlatform.isDarwin && finalAttrs.doInstallCheck;

  pythonImportsCheck = [ "kaleido" ];

  passthru.tests = {
    irisplot = callPackage ./tests.nix { };
  };

  meta = {
    description = "Fast static image export for web-based visualization libraries";
    homepage = "https://github.com/plotly/Kaleido";
    changelog = "https://github.com/plotly/Kaleido/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
