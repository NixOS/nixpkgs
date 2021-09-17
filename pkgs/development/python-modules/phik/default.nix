{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytest
, pytest-pylint
, nbconvert
, joblib
, jupyter_client
, numpy
, scipy
, pandas
, matplotlib
, numba
}:

buildPythonPackage rec {
  pname = "phik";
  version = "0.12.0";
  format = "wheel";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    sha256 = "57db39d1c74c84a24d0270b63d1c629a5cb975462919895b96a8522ae0678408";
  };

  checkInputs = [
    pytest
    pytest-pylint
    nbconvert
    jupyter_client
  ];

  propagatedBuildInputs = [
    joblib
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
