{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyopenssl,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-pkcs12";
  version = "1.27";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "m-click";
    repo = "requests_pkcs12";
    rev = version;
    hash = "sha256-4B7jL3OubIF8ZOYzsODltZCAHhb+PM18uJDOssuM6R4=";
  };

  propagatedBuildInputs = [
    requests
    pyopenssl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "requests_pkcs12" ];

  meta = {
    description = "PKCS#12 support for the Python requests library";
    homepage = "https://github.com/m-click/requests_pkcs12";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
