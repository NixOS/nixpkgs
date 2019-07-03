{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "Events";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4d9c41a5c160ce504278f219fe56f44242ca63794a0ad638b52d1e087ac2a41";
  };

  meta = with lib; {
    homepage = https://events.readthedocs.org;
    description = "Bringing the elegance of C# EventHanlder to Python";
    license = licenses.bsd3;
  };
}
