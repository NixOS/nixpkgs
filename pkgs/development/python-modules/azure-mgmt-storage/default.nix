{ lib
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, isPy3k
}:

buildPythonPackage rec {
  version = "8.0.0";
  pname = "azure-mgmt-storage";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "636778912823cebed1c212e4feacc4885d9e49e19a047da20fca9393bc6fac33";
  };

  postInstall = if isPy3k then "" else ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
  '';

  propagatedBuildInputs = [ azure-mgmt-common ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Storage Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
