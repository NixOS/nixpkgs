{ lib
, fetchPypi
, buildPythonPackage
, packaging
, lightning-utilities
, numpy
, fsspec
, torch
}:

buildPythonPackage rec {
  pname = "lightning-lite";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pxlAQJ09GluyD2NxbIanRRV84wEA8cFmAN/jPZtleVU=";
  };

  propagatedBuildInputs = [
    fsspec
    lightning-utilities
    numpy
    packaging
    torch
  ];

  pythonImportsCheck = [ "lightning_lite" ];

  meta = with lib; {
    description = "Lightweight PyTorch wrapper for machine learning researchers";
    homepage = "https://pytorch-lightning.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
  };
}
