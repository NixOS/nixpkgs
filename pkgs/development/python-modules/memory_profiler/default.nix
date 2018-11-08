{ stdenv
, python
}:

python.pkgs.buildPythonPackage rec {
  pname = "memory_profiler";
  version = "0.54.0";

  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "06ld8h8mhm8pk0sv7fxgx0y2q8nri65qlh4vjbs0bq9j7yi44hyn";
  };

  propagatedBuildInputs = with python.pkgs; [
    psutil # needed to profile child processes
    matplotlib # needed for plotting memory usage
  ];

  meta = with stdenv.lib; {
    description = "A module for monitoring memory usage of a process";
    longDescription = ''
      This is a python module for monitoring memory consumption of a process as
      well as line-by-line analysis of memory consumption for python programs.
    '';
    homepage = https://pypi.python.org/pypi/memory_profiler;
    license = licenses.bsd3;
  };
}
