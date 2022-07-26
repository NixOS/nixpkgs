{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, oauthlib
, python-dateutil
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "discogs-client";
  version = "2.3.15";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "joalla";
    repo = "discogs_client";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-teI0sbvluwVFmEOL/V1zLNGFVbeM7QzZ9rCOl3+A+aY=";
  };

  propagatedBuildInputs = [
    requests
    oauthlib
    python-dateutil
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "discogs_client"
  ];

  meta = with lib; {
    description = "Unofficial Python API client for Discogs";
    homepage = "https://github.com/joalla/discogs_client";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
