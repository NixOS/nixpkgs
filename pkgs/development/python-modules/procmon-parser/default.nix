{
  lib,
  buildPythonPackage,
  construct,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "procmon-parser";
  version = "0.3.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eronnen";
    repo = "procmon-parser";
    tag = "v${version}";
    hash = "sha256-XkMf3MQK4WFRLl60XHDG/j2gRHAiz7XL9MmC6SRg9RE=";
  };

  propagatedBuildInputs = [
    construct
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dateutil
  ];

  pythonImportsCheck = [ "procmon_parser" ];

  meta = with lib; {
    description = "Parser to process monitor file formats";
    homepage = "https://github.com/eronnen/procmon-parser/";
    changelog = "https://github.com/eronnen/procmon-parser/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
