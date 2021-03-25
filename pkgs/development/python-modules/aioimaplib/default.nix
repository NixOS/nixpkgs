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
, pythonOlder
, pytz
, tzlocal
}:

buildPythonPackage rec {
  pname = "aioimaplib";
  version = "0.7.18";

  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = pname;
    rev = version;
    sha256 = "037fxwmkdfb95cqcykrhn37p138wg9pvlsgdf45vyn1mhz5crky5";
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

  # Project is using asynctest with doesn't work with Python 3.8 and above
  # https://github.com/bamthomas/aioimaplib/issues/54
  doCheck = pythonOlder "3.8";
  pythonImportsCheck = [ "aioimaplib" ];

  meta = with lib; {
    description = "Python asyncio IMAP4rev1 client library";
    homepage = "https://github.com/bamthomas/aioimaplib";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
