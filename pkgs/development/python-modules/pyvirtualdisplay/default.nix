{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  substituteAll,
  xorg,

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
    (substituteAll {
      src = ./paths.patch;
      xauth = lib.getExe xorg.xauth;
      xdpyinfo = lib.getExe xorg.xdpyinfo;
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
    xorg.xorgserver
    xorg.xmessage
    xorg.xvfb
  ];

  pytestFlagsArray = [ "-v" ];

  meta = with lib; {
    description = "Python wrapper for Xvfb, Xephyr and Xvnc";
    homepage = "https://github.com/ponty/pyvirtualdisplay";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ layus ];
  };
}
