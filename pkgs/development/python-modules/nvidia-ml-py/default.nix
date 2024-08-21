{
  lib,
  fetchPypi,
  buildPythonPackage,
  substituteAll,
  addDriverRunpath,
}:

buildPythonPackage rec {
  pname = "nvidia-ml-py";
  version = "12.555.43";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-6efxLvHsI0uw3CLSvcdi/6+rOUvcRyoHpDd8lbv5Ov4=";
  };

  patches = [
    (substituteAll {
      src = ./0001-locate-libnvidia-ml.so.1-on-NixOS.patch;
      inherit (addDriverRunpath) driverLink;
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
