{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  fsspec,
  imagehash,
  matplotlib,
  numpy,
  pandas,
  pillow,
  tabulate,
  tqdm,

  # tests
  datasets,
  psutil,
  pytestCheckHook,
  torchvision,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cleanvision";
  version = "0.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cleanlab";
    repo = "cleanvision";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L28HfvUzpZyKuG5wp3fTTHJN4Tq0HtZM+s9/7onMTDM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fsspec
    imagehash
    matplotlib
    numpy
    pandas
    pillow
    tabulate
    tqdm
  ];

  pythonImportsCheck = [ "cleanvision" ];

  nativeCheckInputs = [
    datasets
    psutil
    pytestCheckHook
    torchvision
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Requires accessing s3 (online)
    "test_s3_dataset"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # TypeError: Pickler._batch_setitems() takes 2 positional arguments but 3 were given
    "test_build_hf_dataset"
    "test_hf_dataset_run"
    "test_visualize_indices_hf"
    "test_visualize_sample_images_hf_dataset"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]
    "test_image_sets"
    "test_imagelab_run"
    "test_individual_images"
  ];

  meta = {
    description = "Automatically find issues in image datasets and practice data-centric computer vision";
    homepage = "https://github.com/cleanlab/cleanvision";
    changelog = "https://github.com/cleanlab/cleanvision/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
