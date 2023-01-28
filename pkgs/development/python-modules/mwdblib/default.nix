{ lib
, beautifultable
, buildPythonPackage
, click
, click-default-group
, fetchFromGitHub
, humanize
, keyring
, unittestCheckHook
, python-dateutil
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "mwdblib";
  version = "4.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HQzfa5UmPo+Ccs2eRDwQA9EMzDg7+Nd4jIjBt+7qwzE=";
  };

  propagatedBuildInputs = [
    beautifultable
    click
    click-default-group
    humanize
    keyring
    python-dateutil
    requests
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [
    "mwdblib"
  ];

  meta = with lib; {
    description = "Python client library for the mwdb service";
    homepage = "https://github.com/CERT-Polska/mwdblib";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
