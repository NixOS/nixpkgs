{ lib, buildPythonPackage, fetchPypi, isPy3k, dnspython, idna, ipaddress }:

buildPythonPackage rec {
  pname = "email-validator";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa237a65f6f4da067119b7df3f13e89c25c051327b2b5b66dc075f33d62480d7";
  };

  doCheck = false;

  propagatedBuildInputs = [
    dnspython
    idna
  ] ++ (if isPy3k then [ ] else [ ipaddress ]);

  meta = with lib; {
    description = "A robust email syntax and deliverability validation library for Python 2.x/3.x.";
    homepage    = "https://github.com/JoshData/python-email-validator";
    license     = licenses.cc0;
    maintainers = with maintainers; [ siddharthist ];
    platforms   = platforms.unix;
  };
}
