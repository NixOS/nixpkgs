{ stdenv, lib, buildPythonPackage, fetchPypi, isPy3k, dns, idna, ipaddress }:

buildPythonPackage rec {
  pname = "email_validator";
  version = "1.0.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ja9149l9ck5n45a72h3is7v476hjny5ybxbcamx1nw6iplsm7k6";
  };

  doCheck = false;

  propagatedBuildInputs = [
    dns
    idna
  ] ++ (if isPy3k then [ ] else [ ipaddress ]);

  meta = with lib; {
    description = "A robust email syntax and deliverability validation library for Python 2.x/3.x.";
    homepage    = https://github.com/JoshData/python-email-validator;
    license     = licenses.cc0;
    maintainers = with maintainers; [ siddharthist ];
    platforms   = platforms.unix;
  };
}
