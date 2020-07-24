{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, pytest-pylint
, nbconvert
, jupyter_client
, numpy
, scipy
, pandas
, matplotlib
, numba
}:

buildPythonPackage rec {
  pname = "phik";
  version = "0.10.0";
  format = "wheel";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    sha256 = "b745313c5ff9d6a3092eefa97f83fa4dbed178c9ce69161b655e95497cb2f38b";
  };

  checkInputs = [
    pytest
    pytest-pylint
    nbconvert
    jupyter_client
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    pandas
    matplotlib
    numba
  ];

  postInstall = ''
  rm -r $out/bin
  '';

  meta = with lib; {
    description = "Phi_K correlation analyzer library";
    longDescription = "Phi_K is a new and practical correlation coefficient based on several refinements to Pearson’s hypothesis test of independence of two variables.";
    homepage = "https://phik.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ melsigl ];
    license = licenses.asl20;
  };
}
