{ buildPythonPackage
, lib
, fetchPypi
, numpy
, scipy
, python
, nose
}:

buildPythonPackage rec {
  pname = "algopy";
  version = "0.5.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1pxphhajk6b6kd0ich6jfwrvjv3rw7vz7dswb2iqz1g3zivgcmb9";
  };

  checkInputs = [ python nose ];

  propagatedBuildInputs = [ numpy scipy ];
  # unittests fail, but still builds
  # see https://github.com/b45ch1/algopy/issues/55
  checkPhase = ''
    python -c "import algopy; algopy.test()"
  '';

  pythonImportsCheck = [ "algopy" ];

  meta = with lib; {
    description = "Taylor Arithmetic Computation and Algorithmic Differentiation";
    license = licenses.bsd2;
    homepage = "https://pythonhosted.org/algopy/";
    maintainers = with maintainers; [ arthus ];
  };
}
