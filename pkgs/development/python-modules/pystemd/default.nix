{ stdenv
, buildPythonPackage
, lib
, python
, fetchPypi
, systemd
, pytest
, mock
, pkg-config }:

buildPythonPackage rec {
  pname = "pystemd";
  version = "0.13.2";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tc+ksTpVaFxJ09F8EGMeyhjDN3D2Yxb47yM3uJUcwUQ=";
  };

  disabled = python.pythonOlder "3.4";

  buildInputs = [ systemd ];

  nativeBuildInputs = [ pkg-config ];

  nativeCheckInputs = [ pytest mock ];

  checkPhase = "pytest tests";

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = ''
      Thin Cython-based wrapper on top of libsystemd, focused on exposing the
      dbus API via sd-bus in an automated and easy to consume way
    '';
    homepage = "https://github.com/facebookincubator/pystemd/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ flokli ];
  };
}
