{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-common
, azure-mgmt-nspkg
, requests
, msrestazure
}:

buildPythonPackage rec {
  version = "0.20.0";
  pname = "azure-mgmt-common";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1rmzpz3733wv31rsnqpdy4bbafvk5dhbqx7q0xf62dlz7p0i4f66";
  };

  propagatedBuildInputs = [ azure-common azure-mgmt-nspkg requests msrestazure ];

  postInstall = ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/mgmt/__init__.py
  '';

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
