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
  version = "0.9.12";
  format = "wheel";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    sha256 = "c4f86e5587e5b456e69bf69d95d07fe7aafc341c40f8f3a21dd5b52272e9ae7b";
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
