{ pkgs
, buildPythonPackage
, fetchPypi
, azure-nspkg
, isPyPy
, python
}:

buildPythonPackage rec {
  version = "1.1.18";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "5fd62ae10b1add97d3c69af970328ec3bd869184396bcf6bfa9c7bc94d688424";
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
