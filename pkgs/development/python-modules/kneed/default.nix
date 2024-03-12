{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, numpy
, scipy
, matplotlib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "kneed";
  version = "0.8.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "arvkevi";
    repo = "kneed";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-oakP6NkdvTzMZcoXS6cKNsRo//K+CoPLlhvbQLGij00=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=kneed" ""
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  checkInputs = [
    pytestCheckHook
    matplotlib
  ];

  disabledTestPaths = [
    # Fails when matplotlib is installed
    "tests/test_no_matplotlib.py"
  ];

  meta = with lib; {
    description = "Knee point detection in Python";
    homepage = "https://github.com/arvkevi/kneed";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tm-drtina ];
  };
}
