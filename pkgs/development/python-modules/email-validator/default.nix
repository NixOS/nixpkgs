{ lib, buildPythonPackage, fetchPypi, isPy3k, dnspython, idna, ipaddress }:

buildPythonPackage rec {
  pname = "email-validator";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a13bd6050d1db4475f13e444e169b6fe872434922d38968c67cea9568cce2f0";
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
