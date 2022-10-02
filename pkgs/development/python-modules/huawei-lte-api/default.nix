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
  version = "1.6.1";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "Salamek";
    repo = "huawei-lte-api";
    rev = "refs/tags/${version}";
    hash = "sha256-ZjSD+/okbFF14YQgCzzH1+FDS+MZQZb1JUINOKdSshs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    pycryptodomex
    requests
    xmltodict
  ];

  checkInputs = [
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
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
