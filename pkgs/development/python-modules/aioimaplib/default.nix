{ lib
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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = pname;
    rev = version;
    sha256 = "sha256-xxZAeJDuqrPv4kGgDr0ypFuZJk1zcs/bmgeEzI0jpqY=";
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

  pythonImportsCheck = [ "aioimaplib" ];

  meta = with lib; {
    description = "Python asyncio IMAP4rev1 client library";
    homepage = "https://github.com/bamthomas/aioimaplib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
