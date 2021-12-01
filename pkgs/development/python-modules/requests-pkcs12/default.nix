{ lib
, buildPythonPackage
, fetchFromGitHub
, pyopenssl
, requests
}:

buildPythonPackage rec {
  pname = "requests-pkcs12";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "m-click";
    repo = "requests_pkcs12";
    rev = version;
    sha256 = "0mc9zpa0d9gijf56mxmsxy4qdcm200ixhnm6i3y5xc2yfv9r6xqy";
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
