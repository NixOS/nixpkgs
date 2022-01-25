{ lib
, buildPythonPackage
, fetchPypi
, cython
, isPyPy
, ipython
, python
, scikit-build
, cmake
, pythonOlder
}:

buildPythonPackage rec {
  pname = "line-profiler";
  version = "3.4.0";

  disabled = pythonOlder "3.6" || isPyPy;

  src = fetchPypi {
    pname = "line_profiler";
    inherit version;
    sha256 = "b6b0a8100a2829358e31ef7c6f427b1dcf2b1d8e5d38b55b219719ecf758aee5";
  };

  nativeBuildInputs = [
    cython
    cmake
    scikit-build
  ];

  propagatedBuildInputs = [
    ipython
  ];

  checkInputs = [
    ipython
  ];

  dontUseCmakeConfigure = true;

  preBuild = ''
    rm -f _line_profiler.c
  '';

  checkPhase = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH cd tests && ${python.interpreter} -m unittest discover -s .
  '';

  pythonImportsCheck = [
    "line_profiler"
  ];

  meta = with lib; {
    description = "Line-by-line profiler";
    homepage = "https://github.com/pyutils/line_profiler";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
