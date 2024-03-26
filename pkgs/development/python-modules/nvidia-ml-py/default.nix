{ lib
, fetchPypi
, buildPythonPackage
, substituteAll
, addOpenGLRunpath
}:

buildPythonPackage rec {
  pname = "nvidia-ml-py";
  version = "12.535.133";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-sVWa8NV90glVv1jQWv/3sWbd1ElH6zBRyZBWOHmesdw=";
  };

  patches = [
    (substituteAll {
      src = ./0001-locate-libnvidia-ml.so.1-on-NixOS.patch;
      inherit (addOpenGLRunpath) driverLink;
    })
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "pynvml" ];

  meta = {
    description = "Python Bindings for the NVIDIA Management Library";
    homepage = "https://pypi.org/project/nvidia-ml-py";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
