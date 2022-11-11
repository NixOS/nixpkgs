{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, urllib3
, pyopenssl
, cryptography
, idna
, certifi
}:

buildPythonPackage rec {
  pname = "domeneshop";
  version = "0.4.2";
  format = "setuptools";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "tr3wsrscIU66kTz3nlvDHj2EXoEHCH3grD0yD7BU3Fc=";
  };

  propagatedBuildInputs = [
    certifi
    urllib3
  ] ++ urllib3.optional-dependencies.secure;

  # There are none
  doCheck = false;

  pythonImportsCheck = [ "domeneshop" ];

  meta = with lib; {
    description = "Python library for working with the Domeneshop API";
    homepage = "https://api.domeneshop.no/docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
