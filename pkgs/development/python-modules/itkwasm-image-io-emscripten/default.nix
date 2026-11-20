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
  pname = "itkwasm-image-io-emscripten";
  version = "1.6.1";
  pyproject = true;

  src = fetchPypi {
    pname = "itkwasm_image_io_emscripten";
    inherit (finalAttrs) version;
    hash = "sha256-lFYLpPM4LVSPANpKGg7WSYrrfvpmE2T1w4igidUUL3I=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  dependencies = [ itkwasm ];

  pythonImportsCheck = [ "itkwasm_image_io_emscripten" ];

  meta = {
    description = "Input and output for scientific and medical image file formats";
    homepage = "https://pypi.org/project/itkwasm-image-io-emscripten";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
