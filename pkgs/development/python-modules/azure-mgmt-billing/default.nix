{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrestazure,
  azure-common,
  azure-mgmt-core,
  azure-mgmt-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-billing";
  version = "6.0.0"; # pypi's 0.2.0 doesn't build ootb
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4f5c5a4188a456fe1eb32b6c45f55ca2069c74be41eb76921840b39f2f5c07f";
    extension = "zip";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-core
    azure-mgmt-nspkg
  ];

  preBuild = ''
    rm -rf azure_bdist_wheel.py
    substituteInPlace setup.cfg \
      --replace "azure-namespace-package = azure-mgmt-nspkg" ""
  '';

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Billing Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
