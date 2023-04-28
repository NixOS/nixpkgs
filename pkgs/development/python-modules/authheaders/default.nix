{ lib
, buildPythonPackage
, fetchPypi
, authres
, dnspython
, dkimpy
, publicsuffix2
, pythonOlder
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.15.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kAzuiKYeZH74Tr38vO4BVDIHRNjsHX1ukmhC9EcoO98=";
  };

  propagatedBuildInputs = [
    authres
    dnspython
    dkimpy
    publicsuffix2
  ];

  pythonImportsCheck = [
    "authheaders"
  ];

  meta = with lib; {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    changelog = "https://github.com/ValiMail/authentication-headers/blob${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
