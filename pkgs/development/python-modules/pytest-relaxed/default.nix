{
  lib,
  buildPythonPackage,
  decorator,
  fetchPypi,
  invoke,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-relaxed";
  version = "2.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lW6gKOww27+2gN2Oe0p/uPgKI5WV6Ius4Bi/LA1xgkg=";
  };

  patches = [
    # https://github.com/bitprophet/pytest-relaxed/issues/28
    # https://github.com/bitprophet/pytest-relaxed/pull/29
    ./fix-oldstyle-hookimpl-setup.patch
  ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ decorator ];

  nativeCheckInputs = [
    invoke
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    "test_skips_pytest_fixtures"
  ];

  pythonImportsCheck = [ "pytest_relaxed" ];

  meta = {
    homepage = "https://pytest-relaxed.readthedocs.io/";
    description = "Relaxed test discovery/organization for pytest";
    changelog = "https://github.com/bitprophet/pytest-relaxed/blob/${version}/docs/changelog.rst";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
}
