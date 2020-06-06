{ lib
, buildPythonPackage
, fetchPypi
, cython
, isPyPy
, ipython
, python
, scikit-build
}:

buildPythonPackage rec {
  pname = "line_profiler";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7218ad6bd81f8649b211974bf108933910f016d66b49651effe7bbf63667d141";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ ipython scikit-build ];

  disabled = isPyPy;

  preBuild = ''
    rm -f _line_profiler.c
  '';

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = {
    description = "Line-by-line profiler";
    homepage = "https://github.com/rkern/line_profiler";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
    broken = true;
  };
}
