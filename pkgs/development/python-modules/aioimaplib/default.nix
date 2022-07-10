{ lib
, pythonOlder
, pythonAtLeast
, asynctest
, buildPythonPackage
, docutils
, fetchFromGitHub
, imaplib2
, mock
, nose
, pyopenssl
, pytestCheckHook
, pytz
, tzlocal
}:

buildPythonPackage rec {
  pname = "aioimaplib";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = pname;
    rev = version;
    hash = "sha256-7Ta0BhtQSm228vvUa5z+pzM3UC7+BskgBNjxsbEb9P0=";
  };

  checkInputs = [
    asynctest
    docutils
    imaplib2
    mock
    nose
    pyopenssl
    pytestCheckHook
    pytz
    tzlocal
  ];

  disabledTests = [
    # https://github.com/bamthomas/aioimaplib/issues/77
    "test_get_quotaroot"
  ];

  pythonImportsCheck = [ "aioimaplib" ];

  meta = with lib; {
    description = "Python asyncio IMAP4rev1 client library";
    homepage = "https://github.com/bamthomas/aioimaplib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
