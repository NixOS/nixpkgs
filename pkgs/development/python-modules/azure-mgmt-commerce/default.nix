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
  pname = "azure-mgmt-commerce";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1hw4crkgb72ps85m2kz9kf8p2wg9qmaagk3z5nydva9g6bnq93n4";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  prePatch = ''
    rm -f azure_bdist_wheel.py tox.ini
    substituteInPlace setup.py \
      --replace "wheel==0.30.0" "wheel"
    sed -i "/azure-namespace-package/c\ " setup.cfg
  '';

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.mgmt.commerce" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Commerce Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
