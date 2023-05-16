{ lib
, python
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python.pkgs.buildPythonPackage rec {
  pname = "memory_profiler";
<<<<<<< HEAD
  version = "0.61.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Tltz14ZKHRKS+3agPoKj5475NNBoKKaY2dradtogZ7A=";
=======
  version = "0.55.0";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1hdgh5f59bya079w4ahx4l0hf4gc5yvaz44irp5x57cj9hkpp92z";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python.pkgs; [
    psutil # needed to profile child processes
    matplotlib # needed for plotting memory usage
  ];

  meta = with lib; {
    description = "A module for monitoring memory usage of a process";
    longDescription = ''
      This is a python module for monitoring memory consumption of a process as
      well as line-by-line analysis of memory consumption for python programs.
    '';
    homepage = "https://pypi.python.org/pypi/memory_profiler";
    license = licenses.bsd3;
  };
}
