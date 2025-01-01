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
  version = "1.25";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "m-click";
    repo = "requests_pkcs12";
    rev = version;
    hash = "sha256-ukS0vxG2Rd71GsF1lmpsDSM2JovwqhXsaAnZdF8WGQo=";
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
