{
  lib,
  buildPythonPackage,
  fetchPypi,
  decorator,
  future,
  lxml,
  matplotlib,
  numpy,
  requests,
  scipy,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "obspy";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-oPKwkVvutZd2JWP6A1iqG01rCf/aSZCcdgtc31vcQZ4=";
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
