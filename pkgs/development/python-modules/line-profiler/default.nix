{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  isPyPy,
  ipython,
  scikit-build,
  cmake,
  pytestCheckHook,
  ubelt,
}:

buildPythonPackage rec {
  pname = "line-profiler";
  version = "5.0.2";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchPypi {
    pname = "line_profiler";
    inherit version;
    hash = "sha256-jYqZDITGS83kWvIq9QLRe8CuEHvkBc5Bu6kq9cOcAAA=";
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

  meta = {
    description = "Line-by-line profiler";
    mainProgram = "kernprof";
    homepage = "https://github.com/pyutils/line_profiler";
    changelog = "https://github.com/pyutils/line_profiler/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
  };
}
