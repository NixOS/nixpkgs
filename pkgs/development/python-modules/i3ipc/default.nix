{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  coreutils,
  setuptools,
  xlib,
  fontconfig,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  pytest-asyncio,
  pytest-timeout,
  pytest-xvfb,
  i3,
  xvfb,
  xdpyinfo,
}:

buildPythonPackage rec {
  pname = "i3ipc";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "altdesktop";
    repo = "i3ipc-python";
    tag = "v${version}";
    hash = "sha256-JRwipvIF1zL/x2A+xEJKEFV6BlDnv2Xt/eyIzVrSf40=";
  };

  patches = [
    # Upstream fix for short reads on the asyncio command socket.
    # This fixes darwin tests.
    (fetchpatch {
      url = "https://github.com/altdesktop/i3ipc-python/commit/2e6533e8df42c124f2cb10677dbb3639745a6610.patch";
      hash = "sha256-DjJrMLPL1hbufukaWOiC3Utyw2nXs9y7SCKML9DP71g=";
    })

    # Upstream expects a very old version of pytest-asyncio. This patch correctly
    # decorates async fixtures using pytest-asyncio and configures `loop_scope`
    # where needed.
    ./fix-async-tests.patch
  ];

  postPatch = ''
    substituteInPlace test/i3.config \
      --replace-fail /bin/true ${coreutils}/bin/true
  '';

  build-system = [ setuptools ];
  dependencies = [ xlib ];

  # Fontconfig error: Cannot load default config file
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
    pytest-asyncio
    pytest-timeout
    pytest-xvfb
    i3
    xdpyinfo
    xvfb
  ];

  disabledTestPaths = [
    # Timeout
    "test/test_shutdown_event.py::TestShutdownEvent::test_shutdown_event_reconnect"
    "test/aio/test_shutdown_event.py::TestShutdownEvent::test_shutdown_event_reconnect"
    # Flaky
    "test/test_window.py::TestWindow::test_detailed_window_event"
    "test/aio/test_workspace.py::TestWorkspace::test_workspace"
  ];

  pythonImportsCheck = [ "i3ipc" ];

  meta = {
    description = "Improved Python library to control i3wm and sway";
    homepage = "https://github.com/altdesktop/i3ipc-python";
    changelog = "https://github.com/altdesktop/i3ipc-python/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
  };
}
