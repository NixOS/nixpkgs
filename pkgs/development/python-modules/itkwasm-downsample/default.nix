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
  version = "2.0.2";
  pyproject = true;

  src = fetchPypi {
    pname = "itkwasm_downsample";
    inherit (finalAttrs) version;
    hash = "sha256-2X//X492VXmV8t2w4BO936XjjkRTBLvPQ+7G82RLonk=";
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
