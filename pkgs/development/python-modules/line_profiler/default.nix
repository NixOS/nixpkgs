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
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7218ad6bd81f8649b211974bf108933910f016d66b49651effe7bbf63667d141";
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
