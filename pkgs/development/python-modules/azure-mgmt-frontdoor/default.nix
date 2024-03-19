{ azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, lib
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-frontdoor";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-GqrJNNcQrNffgqRywgaJ2xkwy+fOJai/RlSVkpw6NWg=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.frontdoor" ];

  meta = with lib; {
    description = "Microsoft Azure Front Door Service Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
