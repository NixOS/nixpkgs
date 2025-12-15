{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  runCommand,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  dbus-python,

  # checks
  doCheck ? true,
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

  patches = lib.optionals doCheck [
    (fetchpatch {
      name = "networkmanager-1.54.2.patch";
      url = "https://github.com/martinpitt/python-dbusmock/commit/1ce6196a687d324a55fbf1f74e0f66a4e83f7a15.patch";
      hash = "sha256-Wo7AhmZu74cTHT9I36+NGGSU9dcFwmcDvtzgseTj/yA=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ dbus-python ];

  inherit doCheck;

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

  meta = {
    changelog = "https://github.com/martinpitt/python-dbusmock/releases/tag/${src.tag}";
    description = "Mock D-Bus objects for tests";
    homepage = "https://github.com/martinpitt/python-dbusmock";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ callahad ];
    platforms = lib.platforms.linux;
  };
}
