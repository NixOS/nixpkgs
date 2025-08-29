{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  version = "2.6.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kuzmoyev";
    repo = "google-calendar-simple-api";
    rev = "v${version}";
    hash = "sha256-I4IKuG9/4/JrEQ7PD1BwGFmCa1q3GOe4srHmpwt1OUU=";
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

  meta = with lib; {
    description = "Pythonic wrapper for the Google Calendar API";
    homepage = "https://github.com/kuzmoyev/google-calendar-simple-api";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
