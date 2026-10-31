{
  lib,
  buildPythonPackage,
  chardet,
  fetchPypi,
  hatchling,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "binaryornot";
  version = "0.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-zI1Xz6cddP+MKKdyZzTVOoUdAvrZ46VYH7gH+Yn3AvA=";
  };

  build-system = [ hatchling ];

  dependencies = [ chardet ];

  nativeCheckInputs = [ hypothesis ];

  pythonImportsCheck = [ "binaryornot" ];

  meta = {
    description = "Ultra-lightweight pure Python package to check if a file is binary or text";
    homepage = "https://github.com/audreyr/binaryornot";
    changelog = "https://github.com/binaryornot/binaryornot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
