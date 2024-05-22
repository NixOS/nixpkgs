{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  unzip,
}:

buildPythonPackage rec {
  pname = "pytest-catchlog";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w7wxh27sbqwm4jgwrjr9c2gy384aca5jzw9c0wzhl0pmk2mvqab";
    extension = "zip";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ pytest ];
  checkPhase = "make test";

  # Requires pytest < 3.1
  doCheck = false;

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://pypi.python.org/pypi/pytest-catchlog/";
    description = "py.test plugin to catch log messages. This is a fork of pytest-capturelog.";
  };
}
