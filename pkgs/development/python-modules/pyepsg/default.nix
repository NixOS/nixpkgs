{ buildPythonPackage, lib, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pyepsg";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d08fad1e7a8b47a90a4e43da485ba95705923425aefc4e2a3efa540dbd470d7";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with lib; {
    description = "Simple Python interface to epsg.io";
    license = licenses.lgpl3;
    homepage = "https://pyepsg.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ mredaelli ];
  };

}
