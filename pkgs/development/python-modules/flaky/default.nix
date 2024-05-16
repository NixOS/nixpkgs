{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flaky";
  version = "3.8.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RyBKgeyQXz1az71h2uq8raj51AMWFtm8sGGEYXKWmfU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "flaky" ];

  disabledTests = [
    # AssertionError and ValueError
    "test_flaky_plugin_handles_non_ascii_byte_string_in_exception"
    "test_flaky_plugin_identifies_failure"
    "test_something_flaky"
    "test_write_then_read"
    "test_writelines_then_read"
  ];

  meta = with lib; {
    description = "Plugin for pytest that automatically reruns flaky tests";
    homepage = "https://github.com/box/flaky";
    changelog = "https://github.com/box/flaky/blob/v${version}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
