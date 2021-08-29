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
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e73ff429236d59d48ce7028484becfa01449b3d52abdcf7337e0ff2acdc5093c";
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
