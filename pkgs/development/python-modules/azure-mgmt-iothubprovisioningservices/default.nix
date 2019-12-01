{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-iothubprovisioningservices";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "8c37acfd1c33aba845f2e0302ef7266cad31cba503cc990a48684659acb7b91d";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  postInstall = lib.optionalString isPy3k ''
    rm $out/${python.sitePackages}/azure/__init__.py
    rm $out/${python.sitePackages}/azure/mgmt/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure IoTHub Provisioning Services Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/iot?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer mwilsoninsight ];
  };
}
