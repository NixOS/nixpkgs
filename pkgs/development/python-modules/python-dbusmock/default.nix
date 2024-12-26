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
  version = "0.32.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-TOs6wAZDcSD1eP+Hbj78YXoAtKbReC5di5QSpQdwp8E=";
  };

  patches = [
    (fetchpatch {
      name = "musl.patch";
      url = "https://github.com/martinpitt/python-dbusmock/commit/1a8d8722068ef7e5f061336047a72d1a0f253b98.patch";
      hash = "sha256-0j3UXsTMDh1+UolkmoLQXlwHXve81yKiGJ7gDWNZVPY=";
    })
    (fetchpatch {
      name = "os-release.patch";
      url = "https://github.com/martinpitt/python-dbusmock/commit/4b99cff50e8c741f20aef4527b27ccdb2a4053d2.patch";
      hash = "sha256-Xcovv44JeuTvPAtXWJvWE+MxlyloClSJGKZz+C3P5bE=";
    })
    (fetchpatch {
      name = "tests-bluez-5.79.patch";
      url = "https://github.com/martinpitt/python-dbusmock/commit/d5e449bff924ea2b2837843237fbb5d9751c4f89.patch";
      hash = "sha256-CafQ/RhFynjI9eY4Xeu5yS+a29ZiJJnSYUmd74/2Dpg=";
    })
  ];

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
    changelog = "https://github.com/martinpitt/python-dbusmock/releases/tag/${version}";
    description = "Mock D-Bus objects for tests";
    homepage = "https://github.com/martinpitt/python-dbusmock";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ callahad ];
    platforms = platforms.linux;
  };
}
