{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  scikit-learn,
  termcolor,
  tqdm,
  pandas,

  # tests
  cleanvision,
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
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "cleanlab";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cleanlab";
    repo = "cleanlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0H4JTAc2tCtIFklGciXQ+TCWOiJ6kRkqcycJNeIpero=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=65.0,<70.0" "setuptools"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scikit-learn
    termcolor
    tqdm
    pandas
  ];

  nativeCheckInputs = [
    cleanvision
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
    # Incorrect snapshots (AssertionError)
    "test_color_sentence"

    # Requires the datasets we prevent from downloading
    "test_create_imagelab"

    # AssertionError: assert np.int64(36) == 35
    "test_num_label_issues"

    # Non-trivial numpy2 incompatibilities
    # assert np.float64(0.492) == 0.491
    "test_duplicate_points_have_similar_scores"
    # AssertionError: assert 'Annotators [1] did not label any examples.'
    "test_label_quality_scores_multiannotator"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # AttributeError: 'called_once_with' is not a valid assertion.
    # Use a spec for the mock if 'called_once_with' is meant to be an attribute..
    # Did you mean: 'assert_called_once_with'?
    "test_custom_issue_manager_not_registered"
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
    changelog = "https://github.com/cleanlab/cleanlab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
