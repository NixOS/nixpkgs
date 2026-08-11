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
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "itkwasm_downsample_emscripten";
    inherit (finalAttrs) version;
    hash = "sha256-Gz4sO6udvY/5AZzQcB5DE6+pk2cmSMmuQor7wNj9Wv8=";
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
