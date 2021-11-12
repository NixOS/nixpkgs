{ lib
, buildPythonPackage
, cmake
, fetchPypi
, isPy3k
, pytest
, pytest-pylint
, nbconvert
, joblib
, jupyter-client
, numpy
, scipy
, pandas
, matplotlib
, ninja
, numba
, pybind11
}:

buildPythonPackage rec {
  pname = "phik";
  version = "0.12.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "959fd40482246e3f643cdac5ea04135b2c11a487e917af7d4e75843f47183549";
  };

  checkInputs = [
    pytest
    pytest-pylint
    nbconvert
    jupyter-client
  ];

  propagatedBuildInputs = [
    joblib
    numpy
    scipy
    pandas
    matplotlib
    numba
    pybind11
  ];

  # uses setuptools to drive build process
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    ninja
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
