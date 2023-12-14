{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "3.0.2";
  format = "setuptools";
  pname = "azure-nspkg";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "e7d3cea6af63e667d87ba1ca4f8cd7cb4dfca678e4c55fc1cedb320760e39dd0";
  };

  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson ];
  };
}
