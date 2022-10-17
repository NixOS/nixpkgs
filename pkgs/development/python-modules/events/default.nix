{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Events";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01d9dd2a061f908d74a89fa5c8f07baa694f02a2a5974983663faaf7a97180f5";
  };

  meta = with lib; {
    homepage = "https://events.readthedocs.org";
    description = "Bringing the elegance of C# EventHanlder to Python";
    license = licenses.bsd3;
  };
}
