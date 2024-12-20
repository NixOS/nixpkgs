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
  pythonOlder,
  pytz,
  setuptools,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "aioimaplib";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = "aioimaplib";
    rev = "refs/tags/${version}";
    hash = "sha256-TjCPGZGsSb+04kQNzHU3kWBo2vY34ujEqh1GIMIehJc=";
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

  pythonImportsCheck = [ "aioimaplib" ];

  meta = with lib; {
    description = "Python asyncio IMAP4rev1 client library";
    homepage = "https://github.com/bamthomas/aioimaplib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
