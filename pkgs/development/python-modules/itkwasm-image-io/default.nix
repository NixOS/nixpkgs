{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  itkwasm,
  itkwasm-image-io-emscripten,
  itkwasm-image-io-wasi,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "itkwasm-image-io";
  version = "1.6.1";
  pyproject = true;

  src = fetchPypi {
    pname = "itkwasm_image_io";
    inherit (finalAttrs) version;
    hash = "sha256-Iwb6Xd+N3P+QsWhhu5q1Dx/joUClNgHBaWrgUalx0V4=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  dependencies = [
    itkwasm
    itkwasm-image-io-emscripten
    itkwasm-image-io-wasi
  ];

  pythonImportsCheck = [ "itkwasm_image_io" ];

  # No tests available
  doCheck = false;

  meta = {
    description = "Input and output for scientific and medical image file formats";
    homepage = "https://pypi.org/project/itkwasm-image-io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
