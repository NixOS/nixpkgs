{ pkgs
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-nspkg";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "293f286c15ea123761f30f5b1cb5adebe5f1e5009efade923c6dd1e017621bf7";
  };

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
