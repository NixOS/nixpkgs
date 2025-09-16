{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  isPyPy,
  ipython,
  scikit-build,
  cmake,
  pythonOlder,
  pytestCheckHook,
  ubelt,
}:

buildPythonPackage rec {
  pname = "line-profiler";
  version = "5.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8" || isPyPy;

  src = fetchPypi {
    pname = "line_profiler";
    inherit version;
    hash = "sha256-qA8K+wW6DSddnd3F/5fqtjdHEWf/Pmbcx9E1dVBZOYw=";
  };

  nativeBuildInputs = [
    cython
    cmake
    scikit-build
  ];

  optional-dependencies = {
    ipython = [ ipython ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    ubelt
  ]
  ++ optional-dependencies.ipython;

  dontUseCmakeConfigure = true;

  preBuild = ''
    rm -f _line_profiler.c
  '';

  preCheck = ''
    rm -r line_profiler
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "line_profiler" ];

  meta = with lib; {
    description = "Line-by-line profiler";
    mainProgram = "kernprof";
    homepage = "https://github.com/pyutils/line_profiler";
    changelog = "https://github.com/pyutils/line_profiler/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
  };
}
