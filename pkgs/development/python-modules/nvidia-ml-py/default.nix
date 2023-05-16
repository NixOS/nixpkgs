{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "nvidia-ml-py";
<<<<<<< HEAD
  version = "12.535.108";
=======
  version = "11.525.84";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
<<<<<<< HEAD
    hash = "sha256-FB/oGHcaFl+5P3Xb5/Afdnw7r6fBP2h29TWDURsHjuE=";
=======
    hash = "sha256-WckO3WyKdkWL3JVFrLDc+Iv4igrYi2A3v8wFZDqkvVU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
