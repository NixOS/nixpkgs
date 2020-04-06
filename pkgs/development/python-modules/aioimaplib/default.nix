{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, pythonOlder, isPy36
, nose, asynctest, mock, pytz, tzlocal, imaplib2, docutils, pyopenssl }:

buildPythonPackage rec {
  pname = "aioimaplib";
  version = "0.7.15";

  # PyPI tarball doesn't ship tests
  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = pname;
    rev = version;
    sha256 = "15nny3y8pwaizq1zmkg43ym5jszk2hs010z12yn2d0j1fibymwbj";
  };

  disabled = !(isPy3k && pythonOlder "3.7");

  checkInputs = [ nose asynctest mock pytz tzlocal imaplib2 docutils pyopenssl ];

  # https://github.com/bamthomas/aioimaplib/issues/35
  doCheck = !isPy36;

  meta = with lib; {
    description = "Python asyncio IMAP4rev1 client library";
    homepage = https://github.com/bamthomas/aioimaplib;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
