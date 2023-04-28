{ buildPythonPackage, fetchPypi, lib
, authres, dnspython, dkimpy, publicsuffix2
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.15.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kAzuiKYeZH74Tr38vO4BVDIHRNjsHX1ukmhC9EcoO98=";
  };

  propagatedBuildInputs = [ authres dnspython dkimpy publicsuffix2 ];

  meta = with lib; {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    changelog = "https://github.com/ValiMail/authentication-headers/blob${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
