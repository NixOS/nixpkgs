{ lib
, buildPythonPackage
, fetchPypi
, cython_3
, isPyPy
, ipython
, scikit-build
, cmake
, pythonOlder
, pytestCheckHook
, ubelt
}:

buildPythonPackage rec {
  pname = "line-profiler";
  version = "4.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6" || isPyPy;

  src = fetchPypi {
    pname = "line_profiler";
    inherit version;
    hash = "sha256-qlZXiw/1p1b+GAs/2nvWfCe71Hiz0BJGEtjPAOSiHfI=";
  };

  nativeBuildInputs = [
    cython_3
    cmake
    scikit-build
  ];

  passthru.optional-dependencies = {
    ipython = [ ipython ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    ubelt
  ] ++ passthru.optional-dependencies.ipython;

  dontUseCmakeConfigure = true;

  preBuild = ''
    rm -f _line_profiler.c
  '';

  preCheck = ''
    rm -r line_profiler
    export PATH=$out/bin:$PATH
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
