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
  version = "1.3.3";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sunspec";
    repo = "pysunspec2";
    tag = "v${version}";
    hash = "sha256-mVx8Rt5GLyQ2ss0iJPi32Fhl9pD7hsXxW94p+8ri+w4=";
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
