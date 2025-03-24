{
  lib,
  attrs,
  buildPythonPackage,
  docutils,
  fetchPypi,
  od,
  pygments,
  python-dateutil,
  pythonOlder,
  repeated-test,
  setuptools-scm,
  sigtools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "clize";
  version = "5.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
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

  nativeCheckInputs = [
    pygments
    unittestCheckHook
    python-dateutil
    repeated-test
  ];

  pythonImportsCheck = [ "clize" ];

  meta = with lib; {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    changelog = "https://github.com/epsy/clize/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
