{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, nose, asynctest, mock, pytz, tzlocal, imaplib2, docutils }:

buildPythonPackage rec {
  pname = "aioimaplib";
  version = "0.7.13";

  # PyPI tarball doesn't ship tests
  src = fetchFromGitHub {
    owner = "bamthomas";
    repo = pname;
    rev = version;
    sha256 = "19yhk4ixfw46d0bvx6a40r23nvia5a83dzn5rzwaq1wdjr186bbn";
  };

  disbaled = pythonOlder "3.4";

  checkInputs = [ nose asynctest mock pytz tzlocal imaplib2 docutils ];

  meta = with lib; {
    description = "Python asyncio IMAP4rev1 client library";
    homepage = https://github.com/bamthomas/aioimaplib;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
