{ pkgs
, buildPythonPackage
, fetchPypi
, azure-nspkg
, isPyPy
, python
}:

buildPythonPackage rec {
  version = "1.1.19";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "622d9360a1b61172b4c0d1cc58f939c68402aa19ca44872ab3d224d913aa6d0c";
  };

  propagatedBuildInputs = [ azure-nspkg ];

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
