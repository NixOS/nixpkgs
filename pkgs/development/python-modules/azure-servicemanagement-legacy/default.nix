{ pkgs
, buildPythonPackage
, fetchPypi
, azure-common
, requests
, python
}:

buildPythonPackage rec {
  version = "0.20.6";
  pname = "azure-servicemanagement-legacy";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c883ff8fa3d4f4cb7b9344e8cb7d92a9feca2aa5efd596237aeea89e5c10981d";
  };

  propagatedBuildInputs = [ azure-common requests ];

  postInstall = ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
  '';

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
