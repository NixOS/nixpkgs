{
  lib,
  pythonOlder,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  pyserial,
  openpyxl,
}:

buildPythonPackage rec {
  pname = "pysunspec2";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sunspec";
    repo = "pysunspec2";
    tag = "v${version}";
    hash = "sha256-N3Daa1l2uzRbj2GpgdulzNhqxtRLvxZuEHxlKMsAdso=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  dependencies = [
    openpyxl
    pyserial
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sunspec2" ];

  meta = with lib; {
    description = "Python library for interfacing with SunSpec devices";
    homepage = "https://github.com/sunspec/pysunspec2";
    changelog = "https://github.com/sunspec/pysunspec2/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = [ lib.maintainers.cheriimoya ];
  };
}
