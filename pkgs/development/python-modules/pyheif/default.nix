{
  lib,
  buildPythonPackage,
  fetchPypi,
  cffi,
  libheif,
}:

buildPythonPackage rec {
  pname = "pyheif";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hqXFF0N51xRrXtGmiJL69yaKE1+39QOaARv7em6QMgA=";
  };

  propagatedBuildInputs = [
    cffi
    libheif
  ];

  meta = with lib; {
    homepage = "https://github.com/carsales/pyheif";
    description = "Python interface to libheif library";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
