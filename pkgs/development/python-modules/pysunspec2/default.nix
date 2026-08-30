{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  pyserial,
  openpyxl,
}:

buildPythonPackage (finalAtrs: {
  pname = "pysunspec2";
  version = "1.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sunspec";
    repo = "pysunspec2";
    tag = "v${finalAtrs.version}";
    hash = "sha256-9VZy0QwMh9JK0DpECRMhF279lo125Dq1AUaa6gtHuV0=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    openpyxl
    pyserial
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    # This test relies on old pymodbus 2 version
    "--ignore=sunspec2/tests/test_tls_client.py"
  ];

  pythonImportsCheck = [ "sunspec2" ];

  meta = {
    description = "Python library for interfacing with SunSpec devices";
    homepage = "https://github.com/sunspec/pysunspec2";
    changelog = "https://github.com/sunspec/pysunspec2/releases/tag/${finalAtrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.cheriimoya ];
  };
})
