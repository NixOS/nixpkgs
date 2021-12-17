{ buildPythonPackage, fetchPypi, isPy27, lib
, authres, dnspython, dkimpy, ipaddress, publicsuffix2
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e601b5b54080019a2f548fadf80ddf9c5538615607c7fb602936404aafe67e2";
  };

  propagatedBuildInputs = [ authres dnspython dkimpy publicsuffix2 ]
                          ++ lib.optional isPy27 ipaddress;

  meta = {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    license = lib.licenses.mit;
  };
}
