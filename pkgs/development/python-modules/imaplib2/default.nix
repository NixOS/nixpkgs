{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "imaplib2";
  version = "2.45.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a35b6d88258696e80aabecfb784e08730b8558fcaaa3061ff2c7f8637afbd0b3";
  };

  # No tests on PyPI and no tags on GitHub :(
  doCheck = false;

  meta = with lib; {
    description = "A threaded Python IMAP4 client";
    homepage = "https://github.com/bcoe/imaplib2";
    # See https://github.com/bcoe/imaplib2/issues/25
    license = licenses.psfl;
    maintainers = with maintainers; [ dotlambda ];
  };
}
