{ lib
, buildPythonPackage
, fetchFromGitHub
, google-auth
, google-auth-oauthlib
, setuptools
}:

buildPythonPackage rec {
  pname = "pydata-google-auth";
  version = "1.8.2";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pydata";
    rev = "refs/tags/${version}";
    hash = "sha256-Wo+tXbzOuz/cW8GuWoSxLA/Lr2S9NMdePa8tIV39mbY=";
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
