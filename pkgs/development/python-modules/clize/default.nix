{
  lib,
  attrs,
  buildPythonPackage,
  docutils,
  fetchPypi,
  od,
  pygments,
  python-dateutil,
  repeated-test,
  setuptools-scm,
  sigtools,
  unittestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "clize";
  version = "5.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-BH9aRHNgJxirG4VnKn4VMDOHF41agcJ13EKd+sHstRA=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    docutils
    od
    sigtools
  ];

  optional-dependencies = {
    datetime = [ python-dateutil ];
  };

  postPatch = ''
    # the simulated old docutils only ignores the 0.21 wording of these deprecation warnings
    substituteInPlace clize/tests/test_help.py \
      --replace-fail '"message": r".*Option.*\b0\.21\b.*"' '"message": r"The frontend\.Option(Parser)? class .*"'
  '';

  nativeCheckInputs = [
    pygments
    unittestCheckHook
    python-dateutil
    repeated-test
  ];

  unittestFlags = [
    "-s"
    "clize/tests"
  ];

  pythonImportsCheck = [ "clize" ];

  meta = {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    changelog = "https://github.com/epsy/clize/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
