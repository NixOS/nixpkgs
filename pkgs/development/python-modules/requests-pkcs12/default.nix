{ lib
, buildPythonPackage
, fetchFromGitHub
, pyopenssl
, requests
}:

buildPythonPackage rec {
  pname = "requests-pkcs12";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "m-click";
    repo = "requests_pkcs12";
    rev = version;
    sha256 = "09nm3c6v911d1vwwi0f7mzapbkq7rnsl7026pb13j6ma8pkxznms";
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
