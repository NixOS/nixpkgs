{ lib
, buildPythonPackage
, fetchPypi
, msrestazure
, azure-common
, azure-mgmt-nspkg
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-billing";
  version = "1.0.0"; #pypi's 0.2.0 doesn't build ootb

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b55064546c8e94839d9f8c98e9ea4b021004b3804e192bf39fa65b603536ad0";
    extension = "zip";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
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
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
