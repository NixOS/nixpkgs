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
  version = "4.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6" || isPyPy;

  src = fetchPypi {
    pname = "line_profiler";
    inherit version;
    hash = "sha256-JejJ1CSNxIkFgBhR/4p1ucdIJ6CHHRGNEQTY5D1/sPw=";
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
    changelog = "https://github.com/pyutils/line_profiler/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
