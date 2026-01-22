{
  lib,
  asdf-standard,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "asdf-transform-schemas";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "asdf_transform_schemas";
    inherit (finalAttrs) version;
    hash = "sha256-D1D44Jb//S0UucgplZASZu8lsj0N/8MK1Bu6RoUalzI=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ asdf-standard ];

  # Circular dependency on asdf
  doCheck = false;

  pythonImportsCheck = [ "asdf_transform_schemas" ];

  meta = {
    description = "ASDF schemas for validating transform tags";
    homepage = "https://github.com/asdf-format/asdf-transform-schemas";
    changelog = "https://github.com/asdf-format/asdf-transform-schemas/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
