{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyfakefs,
  tzlocal,
  google-api-python-client,
  google-auth-httplib2,
  google-auth-oauthlib,
  python-dateutil,
  beautiful-date,
}:

buildPythonPackage rec {
  pname = "gcsa";
  version = "2.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kuzmoyev";
    repo = "google-calendar-simple-api";
    rev = "v${version}";
    hash = "sha256-lDmdV1F/EFtZEhq4ufH9nPvzNZ9msUGNZcmWiVTTTWc=";
  };

  propagatedBuildInputs = [
    tzlocal
    google-api-python-client
    google-auth-httplib2
    google-auth-oauthlib
    python-dateutil
    beautiful-date
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyfakefs
  ];
  pythonImportsCheck = [ "gcsa" ];

  meta = {
    description = "Pythonic wrapper for the Google Calendar API";
    homepage = "https://github.com/kuzmoyev/google-calendar-simple-api";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
