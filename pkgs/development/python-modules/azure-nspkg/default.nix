{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "3.0.2";
  format = "setuptools";
  pname = "azure-nspkg";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-59POpq9j5mfYe6HKT4zXy038pnjkxV/BztsyB2DjndA=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      olcai
      maxwilson
    ];
  };
}
