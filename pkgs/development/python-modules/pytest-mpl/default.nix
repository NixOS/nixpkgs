{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pytest,
  jinja2,
  matplotlib,
  packaging,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-mpl";
  version = "0.17.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-++8F1+ZktLM0UvtpisGI5SJ5HzJ9405+o329/p1SysY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [
    jinja2
    matplotlib
    packaging
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Following are broken since at least a1548780dbc79d76360580691dc1bb4af4e837f6
    "tests/subtests/test_subtest.py"
  ];

  # need to set MPLBACKEND=agg for headless matplotlib for darwin
  # https://github.com/matplotlib/matplotlib/issues/26292
  # The default tolerance is too strict in our build environment
  # https://github.com/matplotlib/pytest-mpl/pull/9
  # https://github.com/matplotlib/pytest-mpl/issues/225
  preCheck = ''
    export MPLBACKEND=agg
    substituteInPlace pytest_mpl/plugin.py \
      --replace-fail "DEFAULT_TOLERANCE = 2" "DEFAULT_TOLERANCE = 10"
    substituteInPlace tests/test_pytest_mpl.py \
      --replace-fail "DEFAULT_TOLERANCE = 10 if WIN else 2" "DEFAULT_TOLERANCE = 10"
  '';

  meta = with lib; {
    description = "Pytest plugin to help with testing figures output from Matplotlib";
    homepage = "https://github.com/matplotlib/pytest-mpl";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
