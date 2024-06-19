{
  lib,
  asynctest,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  imaplib2,
  mock,
  pyopenssl,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  pytz,
  setuptools,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "aioimaplib";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = "aioimaplib";
    rev = "refs/tags/${version}";
    hash = "sha256-7Ta0BhtQSm228vvUa5z+pzM3UC7+BskgBNjxsbEb9P0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    asynctest
    docutils
    imaplib2
    mock
    pyopenssl
    pytestCheckHook
    pytz
    tzlocal
  ];

  # https://github.com/bamthomas/aioimaplib/issues/54
  doCheck = pythonOlder "3.11";

  disabledTests = [
    # https://github.com/bamthomas/aioimaplib/issues/77
    "test_get_quotaroot"
    # asyncio.exceptions.TimeoutError
    "test_idle"
  ];

  pythonImportsCheck = [ "aioimaplib" ];

  meta = with lib; {
    description = "Python asyncio IMAP4rev1 client library";
    homepage = "https://github.com/bamthomas/aioimaplib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
