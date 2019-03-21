{ lib
, buildPythonPackage
, fetchPypi
, cython
, isPyPy
, ipython
, python
}:

buildPythonPackage rec {
  pname = "line_profiler";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "efa66e9e3045aa7cb1dd4bf0106e07dec9f80bc781a993fbaf8162a36c20af5c";
  };

  buildInputs = [ cython ];

  propagatedBuildInputs = [ ipython ];

  disabled = isPyPy;

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s tests
  '';

  meta = {
    description = "Line-by-line profiler";
    homepage = https://github.com/rkern/line_profiler;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}