{ lib
, buildPythonPackage
, fetchFromGitHub
, google-auth
, google-auth-oauthlib
, setuptools
}:

buildPythonPackage rec {
  pname = "pydata-google-auth";
<<<<<<< HEAD
  version = "1.8.2";
=======
  version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    repo = pname;
    owner = "pydata";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Wo+tXbzOuz/cW8GuWoSxLA/Lr2S9NMdePa8tIV39mbY=";
=======
    hash = "sha256-VJmu7VExWmXBa0cjgppyOgWDLDRMdhOoaOrZoi4WAxo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
