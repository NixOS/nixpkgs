{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, oauth2client
, pytestCheckHook
, pythonOlder
, pyu2f
}:

buildPythonPackage rec {
  pname = "google-reauth";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Google";
    repo = "google-reauth-python";
    rev = "refs/tags/${version}";
    hash = "sha256-J7GVh+iY+69rFzf4hN/KLFZMZ1/S3CL5TZ7SsP5Oy3g=";
  };

  propagatedBuildInputs = [
    oauth2client
    pyu2f
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google_reauth"
  ];

  meta = with lib; {
    description = "Auth plugin allowing use the use of OAuth 2.0 credentials for Google Cloud Storage";
    homepage = "https://github.com/Google/google-reauth-python";
    changelog = "https://github.com/google/google-reauth-python/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
