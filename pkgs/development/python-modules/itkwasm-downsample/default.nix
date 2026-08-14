{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  itkwasm,
  itkwasm-downsample-emscripten,
  itkwasm-downsample-wasi,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "itkwasm-downsample";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "itkwasm_downsample";
    inherit (finalAttrs) version;
    hash = "sha256-LP9sg4VFc1/niioRzAR9cbwdl6fiEkrOpGT7vjj+6LQ=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  dependencies = [
    itkwasm
    itkwasm-downsample-emscripten
    itkwasm-downsample-wasi
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [ "itkwasm_downsample" ];

  meta = {
    description = "Pipelines for downsampling images";
    homepage = "https://pypi.org/project/itkwasm-downsample";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
