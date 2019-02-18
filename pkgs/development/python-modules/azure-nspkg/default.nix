{ pkgs
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "3.0.2";
  pname = "azure-nspkg";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "e7d3cea6af63e667d87ba1ca4f8cd7cb4dfca678e4c55fc1cedb320760e39dd0";
  };

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
