{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jpype1,
  pandas,
  py4j,
  pyjnius,
  jre_minimal,
}:

let
  jre = jre_minimal.override {
    modules = [
      "java.base"
      "java.desktop"
      "java.instrument"
      "java.logging"
      "java.net.http"
      "java.sql"
      "java.xml"
    ];
  };
in
buildPythonPackage (finalAttrs: {
  pname = "jpmml-evaluator-python";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpmml";
    repo = "jpmml-evaluator-python";
    tag = finalAttrs.version;
    hash = "sha256-6B59C1bdHIwvKfI5/3WfP3tFq226vpeAMU0DlwTHhNQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jpype1
    pandas
    py4j
    pyjnius
  ];

  nativeBuildInputs = [ jre ];

  pythonImportsCheck = [ "jpmml_evaluator" ];

  meta = {
    description = "PMML evaluator library for Python";
    homepage = "https://github.com/jpmml/jpmml-evaluator-python";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.b-rodrigues ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
