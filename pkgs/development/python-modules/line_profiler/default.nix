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
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8bd8353e9403b226def4438dbfdb57cafefb24488e49a6039cc63906c0bc8836";
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
