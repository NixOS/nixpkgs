{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  runCommand,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  dbus-python,

  # checks
  dbus,
  gobject-introspection,
  pygobject3,
  bluez,
  networkmanager,
  pytestCheckHook,
}:

let
  # Cannot just add it to path in preCheck since that attribute will be passed to
  # mkDerivation even with doCheck = false, causing a dependency cycle.
  pbap-client = runCommand "pbap-client" { } ''
    mkdir -p "$out/bin"
    ln -s "${bluez.test}/test/pbap-client" "$out/bin/pbap-client"
  '';
in
buildPythonPackage rec {
  pname = "python-dbusmock";
  version = "0.36.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = "python-dbusmock";
    tag = version;
    hash = "sha256-9YnMOQUuwAcrL0ZaQr7iGly9esZaSRIFThQRNUtSndo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ dbus-python ];

  nativeCheckInputs = [
    dbus
    gobject-introspection
    pygobject3
    bluez
    pbap-client
    networkmanager
    pytestCheckHook
  ];

  disabledTests = [
    # wants to call upower, which is a reverse-dependency
    "test_dbusmock_test_template"
    # Failed to execute program org.TestSystem: No such file or directory
    "test_system_service_activation"
    "test_session_service_activation"
  ];

  meta = with lib; {
    changelog = "https://github.com/martinpitt/python-dbusmock/releases/tag/${src.tag}";
    description = "Mock D-Bus objects for tests";
    homepage = "https://github.com/martinpitt/python-dbusmock";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ callahad ];
    platforms = platforms.linux;
  };
}
