{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  imaplib2,
  mock,
  poetry-core,
  pyopenssl,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pytz,
}:

buildPythonPackage rec {
  pname = "aioimaplib";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = "aioimaplib";
    tag = version;
    hash = "sha256-njzSpKPis033eLoRKXL538ljyMOB43chslio1wodrKU=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    imaplib2
    mock
    pyopenssl
    pytest-asyncio
    pytestCheckHook
    pytz
  ];

  disabledTests = [
    # TimeoutError
    "test_idle_start__exits_queue_get_without_timeout_error"
  ];

  pythonImportsCheck = [ "aioimaplib" ];

  meta = with lib; {
    description = "Python asyncio IMAP4rev1 client library";
    homepage = "https://github.com/bamthomas/aioimaplib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
