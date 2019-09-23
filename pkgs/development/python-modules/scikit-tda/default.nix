{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, scikitlearn
, matplotlib
, numba
, umap-learn
, cython
, ripser
, persim
, pillow
, kmapper
, tadasets
, pytest
, isPy27
}:

buildPythonPackage rec {
  pname = "scikit-tda";
  version = "0.0.4";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "scikit-tda";
    repo = "scikit-tda";
    rev = version;
    sha256 = "0a90k6i9fkmc9gf250b4fidx2fzd2qrn025l74mjk51fvf23q13a";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    scikitlearn
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

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest test
  '';

  # tests will be included in next release
  doCheck = false;

  meta = with lib; {
    description = "Topological Data Analysis for humans";
    homepage = https://github.com/scikit-tda/scikit-tda;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
