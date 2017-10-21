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
  version = "2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "739f8ad0e4bcd0cb82e99afc09e00a0351234f6b3f0b1f7f0090a8a2fbbf8381";
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