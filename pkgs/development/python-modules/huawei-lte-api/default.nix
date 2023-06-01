{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pycryptodomex
, pytestCheckHook
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "huawei-lte-api";
  version = "1.6.11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Salamek";
    repo = "huawei-lte-api";
    rev = "refs/tags/${version}";
    hash = "sha256-pOBYMSORgT8WOnhCdazuKucjPoOywnrWa+qCYR5qSls=";
  };

  propagatedBuildInputs = [
    pycryptodomex
    requests
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "huawei_lte_api.AuthorizedConnection"
    "huawei_lte_api.Client"
    "huawei_lte_api.Connection"
  ];

  meta = with lib; {
    description = "API For huawei LAN/WAN LTE Modems";
    homepage = "https://github.com/Salamek/huawei-lte-api";
    changelog = "https://github.com/Salamek/huawei-lte-api/releases/tag/${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
