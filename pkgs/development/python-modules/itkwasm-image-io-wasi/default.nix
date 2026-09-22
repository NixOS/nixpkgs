{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  importlib-resources,
  itkwasm,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "itkwasm-image-io-wasi";
  version = "1.6.1";
  pyproject = true;

  src = fetchPypi {
    pname = "itkwasm_image_io_wasi";
    inherit (finalAttrs) version;
    hash = "sha256-g3w/OPU9N1GxJkW9kKrOvGtVPRVb6zTy5n2nB5WU7+Q=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  dependencies = [
    importlib-resources
    itkwasm
  ];

  pythonImportsCheck = [ "itkwasm_image_io_wasi" ];

  # No tests available
  doCheck = false;

  meta = {
    description = "Input and output for scientific and medical image file formats";
    homepage = "https://pypi.org/project/itkwasm-image-io-wasi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
