{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pycryptodomex,
  pytestCheckHook,
  requests,
  setuptools,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "huawei-lte-api";
  version = "1.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Salamek";
    repo = "huawei-lte-api";
    tag = version;
    hash = "sha256-cSoH3g5olrcv4/IJeRWFR6Yy1ntBuL0zpO1TrnwvIwk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodomex
    requests
    xmltodict
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "huawei_lte_api.AuthorizedConnection"
    "huawei_lte_api.Client"
    "huawei_lte_api.Connection"
  ];

  meta = with lib; {
    description = "API For huawei LAN/WAN LTE Modems";
    homepage = "https://github.com/Salamek/huawei-lte-api";
    changelog = "https://github.com/Salamek/huawei-lte-api/releases/tag/${src.tag}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
