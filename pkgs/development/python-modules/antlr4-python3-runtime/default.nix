{
  lib,
  buildPythonPackage,
  setuptools,
  python,
  antlr4,
}:

buildPythonPackage rec {
  pname = "antlr4-python3-runtime";
  inherit (antlr4.runtime.cpp) version src;

  pyproject = true;

  sourceRoot = "${src.name}/runtime/Python3";

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace tests/TestIntervalSet.py \
      --replace "assertEquals" "assertEqual"
  '';

  # We use an asterisk because this expression is used also for old antlr
  # versions, where there the tests directory is `test` and not `tests`.
  # See e.g in package `baserow`.
  checkPhase = ''
    runHook preCheck

    pushd tests
    ${python.interpreter} run.py
    popd

    runHook postCheck
  '';

  meta = {
    description = "Runtime for ANTLR";
    mainProgram = "pygrun";
    homepage = "https://www.antlr.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
