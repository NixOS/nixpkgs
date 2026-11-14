{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  py4j,
  jpype1,
  jre_minimal,
  jdk,
  numpy,
  pandas,
  pytestCheckHook,
  pythonOlder,
}:

let
  jre = jre_minimal.override {
    modules = [
      "java.base"
      "java.logging"
      "java.net.http"
      "java.desktop"
    ];
    jdk = jdk;
  };
in

buildPythonPackage (finalAttrs: {
  pname = "pypmml";
  version = "1.5.8";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "autodeployai";
    repo = "pypmml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PNgwSlYyjOCuvIdqwJ7m62oD8GKF5U94qVMpUyuXRg0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    py4j
    jpype1
  ];

  makeWrapperArgs = [
    "--set JAVA_HOME ${jre}"
  ];

  preCheck = ''
    export JAVA_HOME=${jre}
  '';

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    pandas
    jre
  ];

  disabledTests = [
    "test_jpype"
  ];

  pythonImportsCheck = [ "pypmml" ];

  meta = {
    description = "Python PMML scoring library, Python API for PMML4S";
    homepage = "https://github.com/autodeployai/pypmml";
    changelog = "https://github.com/autodeployai/pypmml/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ b-rodrigues ];
    platforms = lib.platforms.all;
  };
})
