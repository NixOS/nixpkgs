{
  lib,
  buildPythonPackage,
  decorator,
  fetchPypi,
  invocations,
  invoke,
  pytest,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-relaxed";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lW6gKOww27+2gN2Oe0p/uPgKI5WV6Ius4Bi/LA1xgkg=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ decorator ];

  nativeCheckInputs = [
    invocations
    invoke
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "pytest_relaxed" ];

  meta = with lib; {
    homepage = "https://pytest-relaxed.readthedocs.io/";
    description = "Relaxed test discovery/organization for pytest";
    changelog = "https://github.com/bitprophet/pytest-relaxed/blob/${version}/docs/changelog.rst";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
