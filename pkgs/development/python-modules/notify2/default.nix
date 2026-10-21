{
  buildPythonPackage,
  lib,
  fetchPypi,
  pygobject3,
  dbus-python,
}:

buildPythonPackage rec {
  pname = "notify2";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-M/oQjVDELzzTQHzEN1GK0/YiXRuyNwEfFjk8ndPOGX0=";
  };

  # Tests require Xorg and Dbus instance
  doCheck = false;
  propagatedBuildInputs = [
    pygobject3
    dbus-python
  ];

  meta = {
    description = "Pure Python interface to DBus notifications";
    homepage = "https://bitbucket.org/takluyver/pynotify2";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mog ];
  };
}
