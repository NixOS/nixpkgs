{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  version = "3.0.2";
  pyproject = true;
  pname = "azure-nspkg";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "e7d3cea6af63e667d87ba1ca4f8cd7cb4dfca678e4c55fc1cedb320760e39dd0";
  };

  build-system = [ setuptools ];

  doCheck = false;

  meta = {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      olcai
      maxwilson
    ];
  };
}
