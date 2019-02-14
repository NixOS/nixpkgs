{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
}:

buildPythonPackage rec {
  version = "3.1.1";
  pname = "azure-mgmt-storage";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "22a779cae5e09712b7d62ef9bc3d8907a5666893a8a113b6d9348e933170236f";
  };

  preConfigure = ''
    # Patch to make this package work on requests >= 2.11.x
    # CAN BE REMOVED ON NEXT PACKAGE UPDATE
    sed -i 's|len(request_content)|str(len(request_content))|' azure/mgmt/storage/storagemanagement.py
  '';

  postInstall = ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
  '';

  propagatedBuildInputs = [ azure-mgmt-common ];

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
