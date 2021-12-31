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
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6b0a8100a2829358e31ef7c6f427b1dcf2b1d8e5d38b55b219719ecf758aee5";
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
