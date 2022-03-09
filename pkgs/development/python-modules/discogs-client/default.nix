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
  version = "2.3.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "joalla";
    repo = "discogs_client";
    rev = "v${version}";
    sha256 = "sha256-TOja0pCJv8TAI0ns8M/tamZ5Pp8k5sSKDnvN4SeKtW8=";
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
