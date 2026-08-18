{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytest,
  jinja2,
  matplotlib,
  packaging,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-mpl";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matplotlib";
    repo = "pytest-mpl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qSOGGq2lOikm3kwZmGI1hFkuPU+zuh0iGL9TbH6ktEQ=";
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
    # https://github.com/matplotlib/pytest-mpl/issues/263
    "tests/test_baseline_path.py::test_config"
    "tests/test_results_always.py::test_config"
    "tests/test_use_full_test_name.py::test_config"
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

  meta = {
    changelog = "https://github.com/matplotlib/pytest-mpl/blob/${finalAttrs.src.tag}/CHANGES.md";
    description = "Pytest plugin to help with testing figures output from Matplotlib";
    homepage = "https://github.com/matplotlib/pytest-mpl";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
