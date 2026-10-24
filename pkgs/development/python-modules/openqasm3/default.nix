{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # nativeBuildInputs
  antlr4,

  # optional-dependencies
  antlr4-python3-runtime,

  # tests
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "openqasm3";
  version = "1.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "openqasm";
    repo = "openqasm";
    tag = "ast-py/v${finalAttrs.version}";
    hash = "sha256-nqZD0Z/W+Lp+jmXjHPc4p1xxoORvI3oHSCTiCTBXSL0=";
  };

  sourceRoot = "${finalAttrs.src.name}/source/openqasm";

  # Upstream only ships the ANTLR-generated parsers in the PyPI artifacts.
  # Generate them with the same ANTLR version as antlr4-python3-runtime.
  nativeBuildInputs = [ antlr4 ];

  preBuild =
    let
      antlrVersion = lib.versions.majorMinor antlr4.version;
      outDir = "openqasm3/_antlr/_${lib.replaceStrings [ "." ] [ "_" ] antlrVersion}";
    in
    ''
      pushd ../grammar
      antlr4 -o "$OLDPWD/${outDir}" -Dlanguage=Python3 -visitor qasm3Lexer.g4 qasm3Parser.g4
      popd
      echo "${antlr4.version}" > antlr_versions.txt
      python tools/update_antlr_version_requirements.py setup.cfg antlr_versions.txt
    '';

  build-system = [ setuptools ];

  optional-dependencies = {
    parser = [ antlr4-python3-runtime ];
  };

  pythonImportsCheck = [
    "openqasm3"
    "openqasm3.parser"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ]
  ++ finalAttrs.passthru.optional-dependencies.parser;

  meta = {
    description = "Reference OpenQASM AST in Python";
    homepage = "https://github.com/openqasm/openqasm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
