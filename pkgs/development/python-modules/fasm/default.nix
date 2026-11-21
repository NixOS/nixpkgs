{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  cmake,
  jre_headless,
  antlr4_9,
  textx,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "fasm";
  version = "0.0.2-unstable-2023-10-09";
  pyproject = true;

  # The openXC7 fork, which nextpnr-xilinx and prjxray use.
  src = fetchFromGitHub {
    owner = "openXC7";
    repo = "fasm";
    rev = "2f57ccb1727a120e8cacbb95c578f3c71bdcc95a";
    fetchSubmodules = true;
    hash = "sha256-4Na24czHPGvxuNuWKDiLkoBamsbqjGQkaQc8ogYHtuA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "self.antlr_runtime = 'static'" "self.antlr_runtime = 'shared'"
    substituteInPlace src/CMakeLists.txt \
      --replace-fail '$'{CMAKE_CURRENT_SOURCE_DIR}/../third_party/antlr4_lib/antlr-4.9.3-complete.jar \
        ${antlr4_9}/share/java/antlr-4.9.3-complete.jar
    substituteInPlace third_party/googletest/googletest/src/gtest-death-test.cc \
      --replace-fail "#include <utility>" $'#include <utility>\n#include <cstdint>'
  '';

  # setup.py runs CMake for the ANTLR parser itself.
  dontUseCmakeConfigure = true;
  env = {
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";
    ANTLR4_RUNTIME_INCLUDE = "${lib.getDev antlr4_9.runtime.cpp}/include/antlr4-runtime";
  };

  build-system = [
    setuptools
    cython
  ];

  nativeBuildInputs = [
    cmake
    jre_headless
  ];

  buildInputs = [ antlr4_9.runtime.cpp ];

  dependencies = [ textx ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Test the installed package, which has the compiled parser.
  preCheck = ''
    rm -r fasm
  '';

  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [
    "fasm"
    "fasm.parser.antlr"
  ];

  meta = {
    description = "FPGA Assembly (FASM) parser and generator";
    homepage = "https://github.com/openXC7/fasm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gonsolo ];
  };
}
