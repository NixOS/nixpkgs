{
  lib,
  fetchPypi,
  buildPythonPackage,

  numpy,
  opencv4,
  pyzbar,
  qrdet,
}:

buildPythonPackage rec {
  pname = "qreader";
  version = "1.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+W0oecn0f5ZB2lXcPh33Zc1Nbxz7yLf6gRtwweJ9T7o=";
  };

  dependencies = [
    numpy
    opencv4
    pyzbar
    qrdet
  ];

  meta = {
    description = "Library for detecting and reading QR codes within images";
    homepage = "https://github.com/Eric-Canas/qreader";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nova ];
    platforms = lib.platforms.all;
  };
}
