{ buildPythonPackage, fetchPypi, isPy27, lib
, authres, dnspython, dkimpy, ipaddress, publicsuffix2
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "935726b784cc636cbcfed2c977f1a6887dc60056806da4eff60db932c5896692";
  };

  propagatedBuildInputs = [ authres dnspython dkimpy publicsuffix2 ]
                          ++ lib.optional isPy27 ipaddress;

  meta = {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    license = lib.licenses.mit;
  };
}
