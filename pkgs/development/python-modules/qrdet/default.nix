{
  lib,
  fetchPypi,
  buildPythonPackage,

  numpy,
  quadrilateral-fitter,
  requests,
  tqdm,
  ultralytics,
}:

buildPythonPackage rec {
  pname = "qrdet";
  version = "2.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7RdC2sP0q7UKW3VJB3bn+jXcsJjZtr6KPcCDUem/3IA=";
  };

  dependencies = [
    numpy
    quadrilateral-fitter
    requests
    tqdm
    ultralytics
  ];

  meta = {
    description = "QR detector library based on YOLOv8";
    homepage = "https://github.com/Eric-Canas/qrdet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nova ];
    platforms = lib.platforms.all;
  };
}
