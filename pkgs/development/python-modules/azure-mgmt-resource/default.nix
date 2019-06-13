{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
}:


buildPythonPackage rec {
  version = "2.1.0";
  pname = "azure-mgmt-resource";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "aef8573066026db04ed3e7c5e727904e42f6462b6421c2e8a3646e4c4f8128be";
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
