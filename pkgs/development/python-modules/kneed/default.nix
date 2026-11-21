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
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arvkevi";
    repo = "kneed";
    tag = "v${version}";
    hash = "sha256-P35E/3DyT+W9qtDTB5PQzGNgxHP4FwOj+vFlhClphc8=";
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
