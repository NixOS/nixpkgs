{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  numpy,
  scikit-learn,
  termcolor,
  tqdm,
  pandas,
  setuptools,
  # test dependencies
  datasets,
  fasttext,
  hypothesis,
  keras,
  matplotlib,
  pytestCheckHook,
  pytest-lazy-fixture,
  skorch,
  tensorflow,
  torch,
  torchvision,
  wget,
}:

buildPythonPackage rec {
  pname = "cleanlab";
  version = "2.6.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cleanlab";
    repo = "cleanlab";
    rev = "refs/tags/v${version}";
    hash = "sha256-wehvGh27Ey1YK+eWTjT6jRwa7yqPpx3P0HUNePoljpw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scikit-learn
    termcolor
    tqdm
    pandas
  ];

  # This is ONLY turned off when we have testing enabled.
  # The reason we do this is because of duplicate packages in the enclosure
  # when using the packages in nativeCheckInputs.
  # Affected packages: grpcio protobuf tensorboard tensorboard-plugin-profile
  catchConflicts = (!doCheck);
  doCheck = true;

  nativeCheckInputs = [
    datasets
    fasttext
    hypothesis
    keras
    matplotlib
    pytestCheckHook
    pytest-lazy-fixture
    skorch
    tensorflow
    torch
    torchvision
    wget
  ];

  disabledTests = [
    # Requires the datasets we prevent from downloading
    "test_create_imagelab"
  ];

  disabledTestPaths = [
    # Requires internet
    "tests/test_dataset.py"
    # Requires the datasets we just prevented from downloading
    "tests/datalab/test_cleanvision_integration.py"
    # Fails because of issues with the keras derivation
    "tests/test_frameworks.py"
  ];

  meta = {
    description = "Standard data-centric AI package for data quality and machine learning with messy, real-world data and labels";
    homepage = "https://github.com/cleanlab/cleanlab";
    changelog = "https://github.com/cleanlab/cleanlab/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
