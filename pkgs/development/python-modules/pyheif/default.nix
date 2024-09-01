{
  lib,
  buildPythonPackage,
  fetchPypi,
  cffi,
  libheif,
}:

buildPythonPackage rec {
  pname = "pyheif";
  version = "0.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6bTBHrrUgvwloIBM4pW0S2YMv3gpoij1awcfMl+eDeQ=";
  };

  propagatedBuildInputs = [
    cffi
    libheif
  ];

  meta = with lib; {
    homepage = "https://github.com/carsales/pyheif";
    description = "Python interface to libheif library";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
