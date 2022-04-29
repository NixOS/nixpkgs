{ buildPythonPackage, fetchPypi, isPy27, lib
, authres, dnspython, dkimpy, ipaddress, publicsuffix2
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-90rOvu+CbHtammrMDZpPx7rIboIT2X/jL1GtfjpmuOk=";
  };

  propagatedBuildInputs = [ authres dnspython dkimpy publicsuffix2 ]
                          ++ lib.optional isPy27 ipaddress;

  meta = {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    license = lib.licenses.mit;
  };
}
