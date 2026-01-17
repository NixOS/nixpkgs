{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  numpy,
  scipy,
  matplotlib,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "kneed";
  version = "0.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arvkevi";
    repo = "kneed";
    tag = "v${version}";
    sha256 = "sha256-oakP6NkdvTzMZcoXS6cKNsRo//K+CoPLlhvbQLGij00=";
  };

  build-system = [ hatchling ];

  dependencies = [
    numpy
    scipy
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov-stub
    matplotlib
  ];

  disabledTestPaths = [
    # Fails when matplotlib is installed
    "tests/test_no_matplotlib.py"
  ];

  meta = {
    description = "Knee point detection in Python";
    homepage = "https://github.com/arvkevi/kneed";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tm-drtina ];
  };
}
