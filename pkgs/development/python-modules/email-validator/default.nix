{ lib, buildPythonPackage, fetchPypi, isPy3k, dnspython, idna, ipaddress }:

buildPythonPackage rec {
  pname = "email_validator";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63094045c3e802c3d3d575b18b004a531c36243ca8d1cec785ff6bfcb04185bb";
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
