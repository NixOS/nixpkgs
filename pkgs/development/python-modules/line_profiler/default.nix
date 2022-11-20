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
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "line-profiler";
  version = "4.0.1";

  disabled = pythonOlder "3.6" || isPyPy;

  src = fetchPypi {
    pname = "line_profiler";
    inherit version;
    sha256 = "sha256-eXlt/5BUxtIZDnRz3umqXqkYqDcgYX5+goSzwBmneek=";
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
    pytestCheckHook
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
