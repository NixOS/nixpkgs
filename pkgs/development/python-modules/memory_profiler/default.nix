{ lib
, python
, fetchPypi
}:

python.pkgs.buildPythonPackage rec {
  pname = "memory_profiler";
  version = "0.61.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Tltz14ZKHRKS+3agPoKj5475NNBoKKaY2dradtogZ7A=";
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
