{ lib, stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "distlib";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "edf6116872c863e1aa9d5bb7cb5e05a022c519a4594dc703843343a9ddd9bff1";
    extension = "zip";
  };

  # Tests use pypi.org.
  doCheck = false;

  meta = with lib; {
    description = "Low-level components of distutils2/packaging";
    homepage = "https://distlib.readthedocs.io";
    license = licenses.psfl;
    maintainers = with maintainers; [ lnl7 ];
  };
}

