{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  systemd,
  lxml,
  psutil,
  pytestCheckHook,
  pkg-config,
  cython,
}:

buildPythonPackage rec {
  pname = "pystemd";
  version = "0.13.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8G1OWyGIGnyRAEkuYMzC9LZOULTWt3c8lAE9LG8aANs=";
  };

  postPatch = ''
    # remove cythonized sources, build them anew to support more python version
    rm pystemd/*.c
  '';

  buildInputs = [ systemd ];

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    lxml
    psutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Having the source root in `sys.path` causes import issues
  preCheck = ''
    cd tests
  '';

  disabledTestPaths = [
    "test_version.py" # Requires cstq which is not in nixpkgs
  ];

  pythonImportsCheck = [ "pystemd" ];

  meta = {
    description = ''
      Thin Cython-based wrapper on top of libsystemd, focused on exposing the
      dbus API via sd-bus in an automated and easy to consume way
    '';
    homepage = "https://github.com/facebookincubator/pystemd/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
