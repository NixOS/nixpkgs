{ lib
, buildPythonPackage
, fetchPypi
, cython
, isPyPy
, ipython
, python
, scikit-build
, cmake
}:

buildPythonPackage rec {
  pname = "line_profiler";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e2fb792ca022f900f374f9659fd3e7c530cd4df7d3b7e84be889093b487639f";
  };

  nativeBuildInputs = [
    cython
    cmake
    scikit-build
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    ipython
  ];

  disabled = isPyPy;

  preBuild = ''
    rm -f _line_profiler.c
  '';

  checkInputs = [
    ipython
  ];

  checkPhase = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH cd tests && ${python.interpreter} -m unittest discover -s .
  '';

  meta = {
    description = "Line-by-line profiler";
    homepage = "https://github.com/rkern/line_profiler";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
