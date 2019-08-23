{ lib
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, isPy3k
}:

buildPythonPackage rec {
  version = "4.0.0";
  pname = "azure-mgmt-storage";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1kxd30s2axn3g4qx3v7q3d5l744a29xlfk3q06ra0rqm1p6prvgv";
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
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/storage?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
