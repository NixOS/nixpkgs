{ lib
, fetchPypi
, python
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "nvidia-ml-py";

  version = "11.515.48";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-iNLQu9c8Q3B+FXMObRTtxqE3B/siJIlIlCH6T0rX+sY=";
  };

  nativeBuildInputs = [ ];
  buildInputs = [ ];

  meta = {
    description = "Python Bindings for the NVIDIA Management Library";
    homepage = "https://pypi.org/project/nvidia-ml-py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
