{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  numpy,
  packaging,
  pydantic,

  # tests
  dask,
  pytest-examples,
  pytestCheckHook,
  xarray,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-zarr";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zarr-developers";
    repo = "pydantic-zarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rgtRN3EXSORa2g2a4aCZacCDLeWM6BosZe5XR0Pg6pU=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    numpy
    packaging
    pydantic
  ];

  pythonImportsCheck = [ "pydantic_zarr" ];

  nativeCheckInputs = [
    dask
    pytest-examples
    pytestCheckHook
    xarray
  ];

  meta = {
    description = "Pydantic models for Zarr";
    homepage = "https://github.com/zarr-developers/pydantic-zarr";
    changelog = "https://github.com/zarr-developers/pydantic-zarr/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      bsd3
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
