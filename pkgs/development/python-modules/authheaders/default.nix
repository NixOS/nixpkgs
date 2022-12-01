{ buildPythonPackage, fetchPypi, lib
, authres, dnspython, dkimpy, publicsuffix2
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-90rOvu+CbHtammrMDZpPx7rIboIT2X/jL1GtfjpmuOk=";
  };

  propagatedBuildInputs = [ authres dnspython dkimpy publicsuffix2 ];

  meta = with lib; {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
