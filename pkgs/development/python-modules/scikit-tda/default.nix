{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, scikit-learn
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
  version = "1.0.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "scikit-tda";
    repo = "scikit-tda";
    rev = "v${version}";
    sha256 = "0yhmf5jmxywyj6l9q0rfv9r8wpdk063fvvfnb4azwwccblgz37rj";
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
    homepage = "https://github.com/scikit-tda/scikit-tda";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
