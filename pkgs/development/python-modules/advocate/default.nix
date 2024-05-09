{ lib
, buildPythonPackage
, fetchFromGitHub
, ndg-httpsclient
, netifaces
, pyasn1
, pyopenssl
, requests
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "advocate";
  version = "1.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "JordanMilne";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-opObkjkad+yrLE2b7DULHjGuNeVhu4fEmSavgA39YPw=";
  };

  propagatedBuildInputs = [
    ndg-httpsclient
    netifaces
    pyasn1
    pyopenssl
    requests
    six
    urllib3
  ];

  # The tests do network requests, so disabled
  doCheck = false;

  pythonImportsCheck = [ "advocate" ];

  meta = with lib; {
    homepage = "https://github.com/JordanMilne/Advocate";
    description = "An SSRF-preventing wrapper around Python's requests library";
    license = licenses.asl20;
    maintainers = with maintainers; [ pborzenkov ];
  };
}
