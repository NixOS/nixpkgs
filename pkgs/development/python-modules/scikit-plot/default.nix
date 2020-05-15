{ stdenv
, buildPythonPackage
, fetchPypi
, matplotlib
, scipy
, scikitlearn
, joblib
, pytest
, python
}:

buildPythonPackage rec {
  version = "0.3.7";
  pname = "scikit-plot";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c7948817fd2dc06879cfe3c1fdde56a8e71fa5ac626ffbe79f043650baa6242";
  };

  buildInputs = [  ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ matplotlib scikitlearn scipy joblib ];

  doCheck = false;

  checkPhase = ''
    pytest scikitplot/tests
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/reiinakano/scikit-plot";
    description = "An intuitive library to add plotting functionality to scikit-learn objects. ";
    license = licenses.mit;
  };
}
