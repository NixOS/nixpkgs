{ lib
, buildPythonPackage
, fetchPypi
, decorator
, future
, lxml
, matplotlib
, numpy
, requests
, scipy
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "obspy";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "a0f2b0915beeb597762563fa0358aa1b4d6b09ffda49909c760b5cdf5bdc419e";
  };

  propagatedBuildInputs = [
    decorator
    future
    lxml
    matplotlib
    numpy
    requests
    scipy
    sqlalchemy
  ];

  # Tests require Internet access.
  doCheck = false;

  pythonImportsCheck = [ "obspy" ];

  meta = with lib; {
    description = "Python framework for seismological observatories";
    homepage = "https://www.obspy.org";
    license = licenses.lgpl3;
    maintainers = [ maintainers.ametrine ];
  };
}
