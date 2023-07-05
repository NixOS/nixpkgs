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
  version = "0.8.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "arvkevi";
    repo = "kneed";
    rev = "v${version}";
    sha256 = "K742mOnwTUY09EtbDYM9guqszK1wxgkofPhSjDyB8Ss=";
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
