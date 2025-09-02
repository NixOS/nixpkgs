{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyopenssl,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-pkcs12";
  version = "1.26";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "m-click";
    repo = "requests_pkcs12";
    rev = version;
    hash = "sha256-EqjB958sGzEC9i6DzLaKsAsIIED7wCh4iG7DCerFV58=";
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
