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
  version = "0.9.8";
  format = "wheel";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    sha256 = "c398452c5c1eea153905666b289c6a153712cf3d58811fa41e2bbbd27a65d678";
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
    homepage = https://phik.readthedocs.io/en/latest/;
    maintainers = with maintainers; [ melsigl ];
    license = licenses.asl20;
  };
}
