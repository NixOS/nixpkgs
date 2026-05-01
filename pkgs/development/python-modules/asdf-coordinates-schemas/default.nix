{
  lib,
  asdf-standard,
  asdf,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "asdf-coordinates-schemas";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asdf-format";
    repo = "asdf-coordinates-schemas";
    tag = finalAttrs.version;
    hash = "sha256-GkYbUCuyDW2t8boYi+dknQ+0Pt6MjvU1PxOYcPfbFLw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asdf
    asdf-standard
  ];

  # Circular dependency with asdf-astropy
  doCheck = false;

  pythonImportsCheck = [ "asdf_coordinates_schemas" ];

  meta = {
    description = "ASDF schemas for coordinates";
    homepage = "https://github.com/asdf-format/asdf-coordinates-schemas";
    changelog = "https://github.com/asdf-format/asdf-coordinates-schemas/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
