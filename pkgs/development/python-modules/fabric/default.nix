{
  lib,
  buildPythonPackage,
  decorator,
  deprecated,
  fetchPypi,
  icecream,
  invoke,
  mock,
  paramiko,
  pytest-relaxed,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fabric";
  version = "3.2.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h4PKQuOwB28IsmkBqsa52bHxnEEAdOesz6uQLBhP9KM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    invoke
    paramiko
    deprecated
    decorator
  ];

  nativeCheckInputs = [
    icecream
    mock
    pytest-relaxed
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/*.py" ];

  pythonImportsCheck = [ "fabric" ];

  disabledTests = [
    # Tests are out-dated
    "calls_RemoteShell_run_with_all_kwargs_and_returns_its_result"
    "executes_arguments_on_contents_run_via_threading"
    "expect"
    "from_v1"
    "honors_config_system_for_allowed_kwargs"
    "llows_disabling_remote_mode_preservation"
    "load"
    "preserves_remote_mode_by_default"
    "proxy_jump"
    "raises_TypeError_for_disallowed_kwargs"
  ];

  meta = {
    description = "Pythonic remote execution";
    homepage = "https://www.fabfile.org/";
    changelog = "https://www.fabfile.org/changelog.html";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "fab";
  };
}
