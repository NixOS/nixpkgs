{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "nvidia-ml-py";
  version = "11.525.131";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-K39NrSXEv0mrnQqaPW4lq9FouRtd6OK23uRwN1bBuuU=";
  };

  patches = [
    ./0001-locate-libnvidia-ml.so.1-on-NixOS.patch
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
