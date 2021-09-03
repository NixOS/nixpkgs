{ lib
, buildPythonPackage
, fetchFromGitHub
, pyopenssl
, requests
}:

buildPythonPackage rec {
  pname = "requests-pkcs12";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "m-click";
    repo = "requests_pkcs12";
    rev = version;
    sha256 = "sha256-fMmca3QNr9UBpSHcVf0nHmGmvkW99bnmigHcWj0D2g0=";
  };

  propagatedBuildInputs = [
    requests
    pyopenssl
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "requests_pkcs12" ];

  meta = with lib; {
    description = "PKCS#12 support for the Python requests library";
    homepage = "https://github.com/m-click/requests_pkcs12";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ fab ];
  };
}
