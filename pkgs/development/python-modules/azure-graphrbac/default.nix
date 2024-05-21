{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
}:

buildPythonPackage rec {
  version = "0.61.1";
  format = "setuptools";
  pname = "azure-graphrbac";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1qmjhpqw0sgy406ij5xyzkffisjah9m1pfz9x54v66bwrbi8msak";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Graph RBAC Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
