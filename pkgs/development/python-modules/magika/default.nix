{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  numpy,
  onnxruntime,
  hatchling,
  python-dotenv,
  tabulate,
  tqdm,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "magika";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MT+Mv83Jp+VcJChicyMKJzK4mCXlipPeK1dlMTk7g5g=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    numpy
    onnxruntime
    python-dotenv
    tabulate
    tqdm
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];

  pythonImportsCheck = [ "magika" ];

  meta = {
    description = "Detect file content types with deep learning";
    homepage = "https://github.com/google/magika";
    changelog = "https://github.com/google/magika/blob/python-v${version}/python/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mihaimaruseac ];
    mainProgram = "magika-python-client";
  };
}
