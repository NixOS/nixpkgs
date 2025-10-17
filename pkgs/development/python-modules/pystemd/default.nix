{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "pystemd";
    tag = "v${version}";
    hash = "sha256-Ph0buiyH2cLRXyqgA8DmpE9crb/x8OaerIoZuv8hjMI=";
  };

  buildInputs = [ systemd ];

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  dependencies = [
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
    homepage = "https://github.com/facebookincubator/pystemd";
    changelog = "https://github.com/systemd/pystemd/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
