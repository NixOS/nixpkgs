{
  lib,
  buildPythonPackage,
  python,
  setuptools,
  antlr4,
}:

buildPythonPackage rec {
  pname = "antlr4-python3-runtime";
  inherit (antlr4.runtime.cpp) version src;

  pyproject = true;
  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "${src.name}/runtime/Python3";

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace tests/TestIntervalSet.py \
      --replace "assertEquals" "assertEqual"
    for file in tests/expr/*.py; do
      substituteInPlace "$file" \
        --replace "from typing.io import TextIO" "from typing import TextIO"
    done
  '';

  checkPhase = ''
    runHook preCheck

    pushd tests
    ${python.interpreter} run.py
    popd

    runHook postCheck
  '';

  meta = {
    description = "Runtime for ANTLR 4.9 (Python 3.14 compatible tests)";
    mainProgram = "pygrun";
    homepage = "https://www.antlr.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
