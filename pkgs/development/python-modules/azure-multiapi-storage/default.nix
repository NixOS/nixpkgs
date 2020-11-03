{ lib, python, buildPythonPackage, fetchPypi, isPy27
, fetchpatch
, azure-common
, azure-core
, msrest
, msrestazure
, requests
}:

buildPythonPackage rec {
  version = "0.4.1";
  pname = "azure-multiapi-storage";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h7bzaqwyl3j9xqzjbnwxp59kmg6shxk76pml9kvvqbwsq9w6fx3";
  };

  requiredPythonModules = [
    azure-common
    azure-core
    msrest
    msrestazure
    requests
  ];

  # Fix to actually install the package
  patches = [
    (fetchpatch {
      url = "https://github.com/Azure/azure-multiapi-storage-python/pull/29/commits/1c8b08dfc9c5445498de3475dec8820eafbd0ca1.patch";
      sha256 = "1f80sdbw4pagrlp9dhcimhp23sdmy0whiba07aa84agkpv4df9ny";
    })
  ];

  # fix namespace
  pythonNamespaces = [ "azure.multiapi" ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.multiapi.storage" ];

  meta = with lib; {
    description = "Microsoft Azure Storage Client Library for Python with multi API version support.";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
