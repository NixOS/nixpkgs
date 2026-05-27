{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  itkwasm,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "itkwasm-downsample-emscripten";
  version = "1.8.1";
  pyproject = true;

  src = fetchPypi {
    pname = "itkwasm_downsample_emscripten";
    inherit (finalAttrs) version;
    hash = "sha256-kF851K6cy1jozPxd5zE8XVnBAHMljmOqtvpmfmQDZy4=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  dependencies = [ itkwasm ];

  pythonImportsCheck = [ "itkwasm_downsample_emscripten" ];

  # No tests available
  doCheck = false;

  meta = {
    description = "Pipelines for downsampling images";
    homepage = "https://pypi.org/project/itkwasm-downsample-emscripten";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
