{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  scikit-learn,
  matplotlib,
  numba,
  umap-learn,
  cython,
  ripser,
  persim,
  pillow,
  kmapper,
  tadasets,
  pytest,
  isPy27,
}:

buildPythonPackage rec {
  pname = "scikit-tda";
  version = "1.1.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "scikit-tda";
    repo = "scikit-tda";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-sf7UxCFJZlIMGOgNFwoh/30U7xsBCZuJ3eumsjEelMc=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    scikit-learn
    matplotlib
    numba
    umap-learn
    cython
    ripser
    persim
    pillow
    kmapper
    tadasets
  ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest test
  '';

  # tests will be included in next release
  doCheck = false;

  meta = with lib; {
    description = "Topological Data Analysis for humans";
    homepage = "https://github.com/scikit-tda/scikit-tda";
    license = licenses.mit;
    maintainers = [ ];
  };
}
