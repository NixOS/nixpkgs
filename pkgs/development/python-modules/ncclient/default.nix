{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  paramiko,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ncclient";
  version = "0.6.19";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ncclient";
    repo = "ncclient";
    tag = "v${version}";
    hash = "sha256-ZAZMazf1PB54MbHyhSuSpg0IWSSqinE2DvHD+L8GKu8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    paramiko
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ncclient" ];

  meta = with lib; {
    description = "Python library for NETCONF clients";
    homepage = "https://github.com/ncclient/ncclient";
    changelog = "https://github.com/ncclient/ncclient/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
