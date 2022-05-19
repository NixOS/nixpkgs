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
, scikit-build
}:

buildPythonPackage rec {
  pname = "phik";
  version = "0.12.2";
  disabled = !isPy3k;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sGdOuCnSMpBDP3GNI2ASK+gEsXDMyAetnZqNHBOYVTM=";
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
    scikit-build
  ];

  pythonImportCheck = [ "phik" ];

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
