{ lib
, buildPythonPackage
, fetchFromGitHub
, google-auth
, google-auth-oauthlib
, setuptools
}:

buildPythonPackage rec {
  pname = "pydata-google-auth";
  version = "1.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pydata";
    rev = "refs/tags/${version}";
    hash = "sha256-PMQj+ySdin02MUBIumyW/PvCGqUhmloDCnBFJggd4I8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-auth
    google-auth-oauthlib
  ];

  # tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "pydata_google_auth"
  ];

  meta = with lib; {
    description = "Helpers for authenticating to Google APIs";
    homepage = "https://github.com/pydata/pydata-google-auth";
    license = licenses.bsd3;
    maintainers = with maintainers; [ cpcloud ];
  };
}
