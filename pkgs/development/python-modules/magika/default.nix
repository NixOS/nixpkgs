{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  click,
  numpy,
  onnxruntime,
  python-dotenv,
  tabulate,
  tqdm,

  # tests
  pytestCheckHook,
  dacite,
  versionCheckHook,
}:

let
  isNotAarch64Linux = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
in
buildPythonPackage (finalAttrs: {
  pname = "magika";
  version = "1.0.1";
  pyproject = true;

  # Use pypi tarball instead of GitHub source
  # Pypi tarball contains a pure python implementation of magika
  # while GitHub source requires compiling magika-cli
  src = fetchPypi {
    inherit (finalAttrs) pname version;
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

  # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
  # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
  #
  # -> Skip all tests that require importing magika
  pythonImportsCheck = lib.optionals isNotAarch64Linux [ "magika" ];
  doCheck = isNotAarch64Linux;

  meta = {
    description = "Detect file content types with deep learning";
    homepage = "https://github.com/google/magika";
    changelog = "https://github.com/google/magika/blob/python-v${finalAttrs.version}/python/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mihaimaruseac ];
    mainProgram = "magika-python-client";
  };
})
