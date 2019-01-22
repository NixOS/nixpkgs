{ pkgs
, buildPythonPackage
, fetchPypi
, azure-nspkg
, isPyPy
, python
}:

buildPythonPackage rec {
  version = "1.1.17";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "e7cd5a8ee2ec0639454c1bd0f1ea5f609d83977376abfd304527ec7343fef1be";
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
