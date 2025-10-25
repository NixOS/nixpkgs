{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-git-versioning,
  choreographer,
  logistro,
  orjson,
  pytestCheckHook,
  pytest-timeout,
  pytest-asyncio,
  plotly,
  numpy,
  pandas,
  hypothesis,
  nix-update-script,
  # Circular dependency on plotly; needs bootstrapping
  withPlotly ? true,
}:

buildPythonPackage rec {
  pname = "kaleido";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "plotly";
    repo = "Kaleido";
    tag = "v${version}";
    hash = "sha256-88qx1wzlaDOp1I9kOZrBV1MytvU5AYCX2qAjTyaPTUc=";
  };

  sourceRoot = "source/src/py";

  build-system = [
    setuptools
    setuptools-git-versioning
  ];
  dependencies = [
    choreographer
    logistro
    orjson
  ];
  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
  ]
  ++ lib.optionals withPlotly [
    plotly

    # Undeclared but used
    hypothesis
    pytest-asyncio
    numpy
    pandas
  ];

  dontUsePytestCheck = !withPlotly;

  disabledTests = [
    # > FAILED tests/test_kaleido.py::test_unreasonable_timeout - choreographer.channels._errors.ChannelClosedError: Executor is closed.
    "test_unreasonable_timeout"
    # > FAILED tests/test_page_generator.py::test_defaults_no_plotly_available - RuntimeError: Plotly cannot be imported during this test, as this tests default behavior while trying to import plotly. The best solution is to make sure this test always runs first, or if you really need to, run it separately and then skip it in the main group.
    "test_defaults_no_plotly_available"
  ];

  pythonImportsCheck = [ "kaleido" ];

  passthru = {
    tests = lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
      irisplot = callPackage ./tests.nix { };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast static image export for web-based visualization libraries with zero dependencies";
    homepage = "https://github.com/plotly/Kaleido";
    changelog = "https://github.com/plotly/Kaleido/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
