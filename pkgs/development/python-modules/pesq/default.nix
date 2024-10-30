{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  # tests
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "pesq";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ludlows";
    repo = "PESQ";
    rev = "refs/tags/v${version}";
    hash = "sha256-JuwZ+trFKGMetS3cC3pEQsV+wbj6+klFnC3THOd8bPE=";
  };

  postPatch =
    # pythonRemoveDeps does not work for removing pytest-runner
    ''
      substituteInPlace setup.py \
        --replace-fail ", 'pytest-runner'" ""
    ''
    # Flaky tests: numerical equality is not satisfied on ARM platforms
    + ''
      substituteInPlace tests/test_pesq.py \
        --replace-fail \
          "assert score == 1.6072081327438354" \
          "assert abs(score - 1.6072081327438354) < 1e-5" \
        --replace-fail \
          "assert score == [1.6072081327438354]" \
          "assert np.allclose(np.array(score), np.array([1.6072081327438354]))"
    '';

  build-system = [
    cython
    setuptools
    numpy
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [
    "pesq"
    "pesq.cypesq"
  ];

  # Prevents importing the `pesq` module from the source files (which lack the cypesq extension)
  preCheck = ''
    rm -rf pesq
  '';

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  meta = {
    description = "PESQ (Perceptual Evaluation of Speech Quality) Wrapper for Python Users";
    homepage = "https://github.com/ludlows/PESQ";
    changelog = "https://github.com/ludlows/PESQ/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
