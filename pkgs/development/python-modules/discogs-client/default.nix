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
<<<<<<< HEAD
  version = "2.7";
=======
  version = "2.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "joalla";
    repo = "discogs_client";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-sTzYhUKPqaCE553FqWR4qdtDDtymhuybHWiDOUwgglA=";
=======
    hash = "sha256-Si1EH5TalNC3BY7L/GqbGSCjDBWzbodB4NZlNayhZYs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
    oauthlib
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "discogs_client"
  ];

  meta = with lib; {
    description = "Unofficial Python API client for Discogs";
    homepage = "https://github.com/joalla/discogs_client";
    changelog = "https://github.com/joalla/discogs_client/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
