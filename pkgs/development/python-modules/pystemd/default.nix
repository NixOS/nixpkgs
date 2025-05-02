{
  buildPythonPackage,
  lib,
  fetchPypi,
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
  format = "setuptools";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tc+ksTpVaFxJ09F8EGMeyhjDN3D2Yxb47yM3uJUcwUQ=";
  };

  postPatch = ''
    # remove cythonized sources, build them anew to support more python version
    rm pystemd/*.c
  '';

  buildInputs = [ systemd ];

  nativeBuildInputs = [
    pkg-config
    cython
  ];

  propagatedBuildInputs = [
    lxml
    psutil
  ];

  nativeCheckInputs = [
    mock
    pytest
  ];

  checkPhase = "pytest tests";

  meta = with lib; {
    description = ''
      Thin Cython-based wrapper on top of libsystemd, focused on exposing the
      dbus API via sd-bus in an automated and easy to consume way
    '';
    homepage = "https://github.com/facebookincubator/pystemd/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ flokli ];
  };
}
