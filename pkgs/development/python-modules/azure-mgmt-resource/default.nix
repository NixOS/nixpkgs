{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
}:


buildPythonPackage rec {
  version = "2.2.0";
  pname = "azure-mgmt-resource";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "173pxgly95dwblp4nj4l70zb0gasibgcjmcynxwa5282plynhgdw";
  };

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
