{ pkgs
, buildPythonPackage
, fetchPypi
, azure-nspkg
}:

buildPythonPackage rec {
  version = "3.0.2";
  pname = "azure-mgmt-nspkg";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "8b2287f671529505b296005e6de9150b074344c2c7d1c805b3f053d081d58c52";
  };

  propagatedBuildInputs = [ azure-nspkg ];

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://azure.microsoft.com/en-us/develop/python/";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
