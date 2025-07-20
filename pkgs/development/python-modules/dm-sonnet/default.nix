{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  dm-tree,
  etils,
  numpy,
  tabulate,
  wrapt,

  # tests
  click,
  docutils,
  keras,
  pytestCheckHook,
  tensorflow,
  tensorflow-datasets,
  tf-keras,
}:

buildPythonPackage rec {
  pname = "dm-sonnet";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "sonnet";
    tag = "v${version}";
    hash = "sha256-WkloUbqSyPG3cbLG8ktsjdluACkCbUZ7t6rYWst8rs8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dm-tree
    etils
    numpy
    tabulate
    wrapt
  ]
  ++ etils.optional-dependencies.epath;

  optional-dependencies = {
    tensorflow = [ tensorflow ];
  };

  nativeCheckInputs = [
    click
    docutils
    keras
    pytestCheckHook
    tensorflow
    tensorflow-datasets
    tf-keras
  ];

  # ImportError: `keras.optimizers.legacy` is not supported in Keras 3
  preCheck = ''
    export TF_USE_LEGACY_KERAS=True
  '';

  disabledTests = [
    # AssertionError: 2 != 0 : 2 doctests failed
    "test_doctest_sonnet.functional"

    # AssertionError: Not equal to tolerance
    "testComputationAgainstNumPy1"

    # tensorflow.python.framework.errors_impl.InvalidArgumentError: cannot compute MatMul as input #1(zero-based) was expected to be a float tensor but is a half tensor [Op:MatMul]
    "testComputationAgainstNumPy0"
    "testComputationAgainstNumPy1"
  ];

  pythonImportsCheck = [ "sonnet" ];

  meta = {
    description = "Library for building neural networks in TensorFlow";
    homepage = "https://github.com/deepmind/sonnet";
    changelog = "https://github.com/google-deepmind/sonnet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
