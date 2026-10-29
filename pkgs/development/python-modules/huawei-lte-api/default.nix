{
  lib,
  buildPythonPackage,
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

  meta = {
    description = "API For huawei LAN/WAN LTE Modems";
    homepage = "https://github.com/Salamek/huawei-lte-api";
    changelog = "https://github.com/Salamek/huawei-lte-api/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
