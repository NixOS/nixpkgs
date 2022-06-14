{ lib
, pythonOlder
, pythonAtLeast
, asynctest
, buildPythonPackage
, docutils
, fetchFromGitHub
, fetchpatch
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
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = pname;
    rev = version;
    sha256 = "sha256-xxZAeJDuqrPv4kGgDr0ypFuZJk1zcs/bmgeEzI0jpqY=";
  };

  patches = [
    # https://github.com/bamthomas/aioimaplib/pull/76
    (fetchpatch {
      url = "https://github.com/bamthomas/aioimaplib/commit/03f796f45b60a163ad0f3d52166d58f280de7065.patch";
      hash = "sha256-9staxkw/EfGoBz/uyrNKBvQ0KfN+za4rTGRyqrAJSd8=";
    })
  ];

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
