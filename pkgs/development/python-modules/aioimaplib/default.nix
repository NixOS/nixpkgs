{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, nose, asynctest, mock, pytz, tzlocal, imaplib2, docutils, pyopenssl }:

buildPythonPackage rec {
  pname = "aioimaplib";
  version = "0.7.14";

  # PyPI tarball doesn't ship tests
  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = pname;
    rev = version;
    sha256 = "150v3czh53sqakfqgjyj1w39mdfcxmpnrk2pbmq63jkq7r6njl0l";
  };

  disabled = pythonOlder "3.4";

  checkInputs = [ nose asynctest mock pytz tzlocal imaplib2 docutils pyopenssl ];

  # https://github.com/bamthomas/aioimaplib/issues/35
  doCheck = false;

  meta = with lib; {
    description = "Python asyncio IMAP4rev1 client library";
    homepage = https://github.com/bamthomas/aioimaplib;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
