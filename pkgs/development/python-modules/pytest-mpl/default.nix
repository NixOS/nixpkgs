{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  pytest,
  jinja2,
  matplotlib,
  pillow,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-mpl";
  version = "0.17.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-++8F1+ZktLM0UvtpisGI5SJ5HzJ9405+o329/p1SysY=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    jinja2
    matplotlib
    pillow
  ];

  nativeCheckInputs = [ pytest7CheckHook ];

  disabledTests = [
    # Broken since b6e98f18950c2b5dbdc725c1181df2ad1be19fee
    "test_hash_fails"
    "test_hash_missing"
  ];

  disabledTestPaths = [
    # Following are broken since at least a1548780dbc79d76360580691dc1bb4af4e837f6
    "tests/subtests/test_subtest.py"
  ];

  # The default tolerance is too strict in our build environment
  # https://github.com/matplotlib/pytest-mpl/pull/9
  # https://github.com/matplotlib/pytest-mpl/issues/225
  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.config/matplotlib
    echo "backend: ps" > $HOME/.config/matplotlib/matplotlibrc
    ln -s $HOME/.config/matplotlib $HOME/.matplotlib

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
