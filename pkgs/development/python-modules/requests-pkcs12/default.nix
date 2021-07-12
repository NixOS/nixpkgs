{ lib
, buildPythonPackage
, fetchFromGitHub
, pyopenssl
, requests
}:

buildPythonPackage rec {
  pname = "requests-pkcs12";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "m-click";
    repo = "requests_pkcs12";
    rev = version;
    sha256 = "sha256-HIUCzHxOsbk1OmcxkRK9GQ+SZ6Uf1xDylOe2pUYz3Hk=";
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
