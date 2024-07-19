{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  msrest,
}:

buildPythonPackage rec {
  pname = "azure-servicefabric";
  version = "8.2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f49c8759447970817b9b2d3d4b97439765dcf75ba01b6066ce96b605052fbb23";
  };

  propagatedBuildInputs = [
    azure-common
    msrest
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This project provides a client library in Python that makes it easy to consume Microsoft Azure Storage services";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
