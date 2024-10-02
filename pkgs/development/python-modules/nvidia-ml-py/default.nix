{
  lib,
  fetchPypi,
  buildPythonPackage,
  substituteAll,
  addDriverRunpath,
}:

buildPythonPackage rec {
  pname = "nvidia-ml-py";
  version = "12.560.30";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-8CVNx0AGR2gKBy7gJQm/1GECtgvf7KMhV21NSBfn/pc=";
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
