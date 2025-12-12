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
  pytestCheckHook,
  dacite,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "magika";
  version = "1.0.1";
  pyproject = true;

  # Use pypi tarball instead of GitHub source
  # Pypi tarball contains a pure python implementation of magika
  # while GitHub source requires compiling magika-cli
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MT+Mv83Jp+VcJChicyMKJzK4mCXlipPeK1dlMTk7g5g=";
  };

  postPatch = ''
    substituteInPlace tests/test_python_magika_client.py \
      --replace-fail 'python_root_dir / "src" / "magika" / "cli" / "magika_client.py"' \
        "Path('$out/bin/magika-python-client')"
  '';

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
    pytestCheckHook
    dacite
    versionCheckHook
  ];

  disabledTests = [
    # These tests require test data which doesn't exist in pypi tarball
    "test_features_extraction_vs_reference"
    "test_reference_generation"
    "test_inference_vs_reference"
    "test_reference_generation"
    "test_magika_module_with_one_test_file"
    "test_magika_module_with_explicit_model_dir"
    "test_magika_module_with_basic"
    "test_magika_module_with_all_models"
    "test_magika_module_with_previously_missdetected_samples"
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
