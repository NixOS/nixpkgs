{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  systemd,
  lxml,
  psutil,
  pytest,
  mock,
  pkg-config,
  cython,
}:

buildPythonPackage rec {
  pname = "pystemd";
  version = "0.13.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tc+ksTpVaFxJ09F8EGMeyhjDN3D2Yxb47yM3uJUcwUQ=";
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
    mock
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    # pytestCheckHook doesn't work
    pytest tests
    runHook postCheck
  '';

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
