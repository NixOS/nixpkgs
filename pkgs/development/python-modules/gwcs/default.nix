{
  lib,
  asdf-astropy,
  asdf-wcs-schemas,
  asdf,
  astropy,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  scipy,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "gwcs";
  version = "1.0.4.dev";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spacetelescope";
    repo = "gwcs";
    tag = finalAttrs.version;
    hash = "sha256-YPdAjPeJHDy9I+JSL+ziNxrX0egd4+JibSsFHAsPGcg=";
  };

  postPatch = ''
    sed -i "/--doctest-rst/d" pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asdf
    asdf-astropy
    asdf-wcs-schemas
    astropy
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "gwcs" ];

  meta = {
    description = "Module to manage the Generalized World Coordinate System";
    homepage = "https://github.com/spacetelescope/gwcs";
    changelog = "https://github.com/spacetelescope/gwcs/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
