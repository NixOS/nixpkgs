{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  replaceVars,
  xorg-server,
  xvfb,
  xmessage,
  xdpyinfo,
  xauth,

  # build-system
  setuptools,

  # tests
  easyprocess,
  entrypoint2,
  pillow,
  psutil,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  vncdo,
}:

buildPythonPackage rec {
  pname = "pyvirtualdisplay";
  version = "3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "PyVirtualDisplay";
    inherit version;
    hash = "sha256-CXVbw86263JfsH7KVCX0PyNY078I4A0qm3kqGu3RYVk=";
  };

  patches = lib.optionals stdenv.hostPlatform.isLinux [
    (replaceVars ./paths.patch {
      xauth = lib.getExe xauth;
      xdpyinfo = lib.getExe xdpyinfo;
    })
  ];

  build-system = [ setuptools ];

  doCheck = stdenv.hostPlatform.isLinux;

  nativeCheckInputs = [
    easyprocess
    entrypoint2
    pillow
    psutil
    pytest-timeout
    pytestCheckHook
    (vncdo.overridePythonAttrs { doCheck = false; })
    xorg-server
    xmessage
    xvfb
  ];

  pytestFlags = [ "-v" ];

  meta = {
    description = "Python wrapper for Xvfb, Xephyr and Xvnc";
    homepage = "https://github.com/ponty/pyvirtualdisplay";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ layus ];
  };
}
