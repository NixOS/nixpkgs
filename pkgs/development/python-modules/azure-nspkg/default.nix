{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  version = "3.0.2";
  pyproject = true;

  __structuredAttrs = true;
  pname = "azure-nspkg";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-59POpq9j5mfYe6HKT4zXy038pnjkxV/BztsyB2DjndA=";
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
})
