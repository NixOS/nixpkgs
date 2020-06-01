{ buildPythonPackage, fetchPypi, isPy27, lib
, authres, dnspython, dkimpy, ipaddress, publicsuffix
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6f96d1dfb7a6cffcdd78d1582914d4f9a0b25d66e1cf5ce959446c92cd8b74f";
  };

  propagatedBuildInputs = [ authres dnspython dkimpy publicsuffix ]
                          ++ lib.optional isPy27 ipaddress;

  meta = {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    license = lib.licenses.mit;
  };
}
