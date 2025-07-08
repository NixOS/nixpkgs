{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  apricot-select,
  networkx,
  numpy,
  scikit-learn,
  scipy,
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pomegranate";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "pomegranate";
    owner = "jmschrei";
    # tag = "v${version}";
    # No tag for 1.1.2
    rev = "e9162731f4f109b7b17ecffde768734cacdb839b";
    hash = "sha256-vVoAoZ+mph11ZfINT+yxRyk9rXv6FBDgxBz56P2K95Y=";
  };

  # _pickle.UnpicklingError: Weights only load failed.
  # https://pytorch.org/docs/stable/generated/torch.load.html
  postPatch = ''
    substituteInPlace \
      tests/distributions/test_bernoulli.py \
      tests/distributions/test_categorical.py \
      tests/distributions/test_exponential.py \
      tests/distributions/test_gamma.py \
      tests/distributions/test_independent_component.py \
      tests/distributions/test_normal_diagonal.py \
      tests/distributions/test_normal_full.py \
      tests/distributions/test_poisson.py \
      tests/distributions/test_student_t.py \
      tests/distributions/test_uniform.py \
      tests/test_bayes_classifier.py \
      tests/test_gmm.py \
      tests/test_kmeans.py \
      --replace-fail \
        'torch.load(".pytest.torch")' \
        'torch.load(".pytest.torch", weights_only=False)'
  '';

  build-system = [ setuptools ];

  dependencies = [
    apricot-select
    networkx
    numpy
    scikit-learn
    scipy
    torch
  ];

  pythonImportsCheck = [ "pomegranate" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # AssertionError: Arrays are not almost equal to 6 decimals
    "--deselect=tests/distributions/test_normal_full.py::test_fit"
    "--deselect=tests/distributions/test_normal_full.py::test_from_summaries"
    "--deselect=tests/distributions/test_normal_full.py::test_serialization"
  ];

  disabledTests = [
    # AssertionError: Arrays are not almost equal to 6 decimals
    "test_sample"
  ];

  meta = {
    description = "Probabilistic and graphical models for Python, implemented in cython for speed";
    homepage = "https://github.com/jmschrei/pomegranate";
    changelog = "https://github.com/jmschrei/pomegranate/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rybern ];
  };
}
