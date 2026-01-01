{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
<<<<<<< HEAD
=======
  magika,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  numpy,
  onnxruntime,
  hatchling,
  python-dotenv,
<<<<<<< HEAD
  tabulate,
  tqdm,
  pytestCheckHook,
  dacite,
  versionCheckHook,
=======
  pythonOlder,
  stdenv,
  tabulate,
  testers,
  tqdm,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "magika";
  version = "1.0.1";
  pyproject = true;
<<<<<<< HEAD

  # Use pypi tarball instead of GitHub source
  # Pypi tarball contains a pure python implementation of magika
  # while GitHub source requires compiling magika-cli
=======
  disabled = pythonOlder "3.9";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MT+Mv83Jp+VcJChicyMKJzK4mCXlipPeK1dlMTk7g5g=";
  };

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace tests/test_python_magika_client.py \
      --replace-fail 'python_root_dir / "src" / "magika" / "cli" / "magika_client.py"' \
        "Path('$out/bin/magika-python-client')"
  '';

  build-system = [ hatchling ];

  dependencies = [
=======
  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    click
    numpy
    onnxruntime
    python-dotenv
    tabulate
    tqdm
  ];

<<<<<<< HEAD
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
=======
  pythonImportsCheck = [ "magika" ];

  passthru.tests.version = testers.testVersion { package = magika; };

  meta = with lib; {
    description = "Detect file content types with deep learning";
    homepage = "https://github.com/google/magika";
    changelog = "https://github.com/google/magika/blob/python-v${version}/python/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mihaimaruseac ];
    mainProgram = "magika-python-client";
    # Currently, disabling on AArch64 as it onnx runtime crashes on ofborg
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
