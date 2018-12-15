{ pkgs
, buildPythonPackage
, fetchPypi
, azure-nspkg
, isPyPy
, python
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-common";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "074rwwy8zzs7zw3nww5q2wg5lxgdc4rmypp2gfc9mwsz0gb70491";
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
