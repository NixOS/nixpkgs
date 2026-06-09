{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-nspkg,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-nspkg";
  version = "3.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-iyKH9nFSlQWylgBebekVCwdDRMLH0cgFs/BT0IHVjFI=";
  };

  build-system = [ setuptools ];

  dependencies = [ azure-nspkg ];

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
})
