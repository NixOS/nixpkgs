{ stdenv
, buildPythonPackage
, pythonOlder
, dbus-python
, pygobject3
}:

buildPythonPackage rec {
  pname = "gatt-python";
  version = "0.2.7";
  disabled = pythonOlder "3.4";

  # there's no 0.2.7 tag on GitHub, which is what fetchPypi would do, so fetch manually
  src = fetchTarball {
    name = "gatt-0.2.7.tar.gz";
    url = "https://files.pythonhosted.org/packages/96/d0/d66154053d5b47996731d80ee66f65bdf7b790258addc0b6a5f50bcc3579/gatt-0.2.7.tar.gz";
    sha256 = "06y9k5gc2r1nh38z21n7w5d1xrwd230avj03l1bm2grfcxxxf1ig";
  };

  propagatedBuildInputs = [
    dbus-python
    pygobject3
  ];

  meta = with stdenv.lib; {
    description = "Bluetooth GATT SDK for Python";
    license = licenses.mit;
  };
}
