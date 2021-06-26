{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, dicttoxml
, requests
, xmltodict
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "huawei-lte-api";
  version = "1.4.18";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "Salamek";
    repo = "huawei-lte-api";
    rev = version;
    sha256 = "1qaqxmh03j10wa9wqbwgc5r3ays8wfr7bldvsm45fycr3qfyn5fg";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    dicttoxml
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
