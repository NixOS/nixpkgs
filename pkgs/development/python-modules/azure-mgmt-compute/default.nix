{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
}:

buildPythonPackage rec {
  version = "4.3.1";
  pname = "azure-mgmt-compute";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "5b0c2390af3e29d910e3d6e7a72b0be59d6e15933740dd193129217c000e4fed";
  };

  preConfigure = ''
    # Patch to make this package work on requests >= 2.11.x
    # CAN BE REMOVED ON NEXT PACKAGE UPDATE
    sed -i 's|len(request_content)|str(len(request_content))|' azure/mgmt/compute/computemanagement.py
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
