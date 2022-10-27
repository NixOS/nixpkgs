{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "nvidia-ml-py";
  version = "11.515.75";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    hash = "sha256-48dfBtWjIB3FETbgDljFwTKzvl1gTYbBQ0Jq205BxJA=";
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
