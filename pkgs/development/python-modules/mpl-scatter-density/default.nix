{
  lib,
  stdenv,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  setuptools-scm,
  setuptools,
  fast-histogram,
  matplotlib,
  numpy,
  wheel,
  pytest-mpl,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "mpl-scatter-density";
  version = "0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "astrofrog";
    repo = "mpl-scatter-density";
    tag = "v${version}";
    hash = "sha256-pDiKJAN/4WFf5icNU/ZGOvw0jqN3eGZHgilm2oolpbE=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    matplotlib
    numpy
    fast-histogram
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
    writableTmpDirAsHomeHook
  ];

  # Need to set MPLBACKEND=agg for headless `matplotlib` on darwin.
  # https://github.com/matplotlib/matplotlib/issues/26292
  env.MPLBACKEND = lib.optionalString stdenv.hostPlatform.isDarwin "agg";

  disabledTests = [
    # AssertionError: (240, 240) != (216, 216)
    # Erroneous pinning of figure DPI, sensitive to runtime environment
    "test_default_dpi"
  ];

  pythonImportsCheck = [ "mpl_scatter_density" ];

  meta = with lib; {
    homepage = "https://github.com/astrofrog/mpl-scatter-density";
    description = "Fast scatter density plots for Matplotlib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ifurther ];
  };
}
