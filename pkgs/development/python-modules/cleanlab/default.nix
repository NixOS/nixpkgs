{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, scikit-learn
, termcolor
, tqdm
, pandas
, setuptools
# test dependencies
, pytestCheckHook
, pytest-lazy-fixture
, tensorflow
, torch
, datasets
, torchvision
, keras
, fasttext
, hypothesis
, wget
, matplotlib
, skorch
}:

buildPythonPackage rec {
  pname = "cleanlab";
  version = "2.5.0";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cleanlab";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5XQQVrhjpvjwtFM79DqttObmw/GQLkMQVXb5jhiC8e0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
    pytestCheckHook
    pytest-lazy-fixture
    tensorflow
    torch
    datasets
    torchvision
    keras
    fasttext
    hypothesis
    wget
    matplotlib
    skorch
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
  ];

  meta = with lib; {
    description = "The standard data-centric AI package for data quality and machine learning with messy, real-world data and labels.";
    homepage = "https://github.com/cleanlab/cleanlab";
    changelog = "https://github.com/cleanlab/cleanlab/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
