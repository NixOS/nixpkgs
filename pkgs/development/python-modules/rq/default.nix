{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, click
, redis
}:

buildPythonPackage rec {
  pname = "rq";
<<<<<<< HEAD
  version = "1.15.1";
=======
  version = "1.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-cymNXFI+6YEVw2Pc7u6+vroC0428oW7BTLxyBgPqLng=";
=======
    hash = "sha256-8X7l59YAO4T0JA3saLzEwirHZniXsp/9Z8q+Tr2HDv0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    click
    redis
  ];

  # Tests require a running Redis rerver
  doCheck = false;

  pythonImportsCheck = [
    "rq"
  ];

  meta = with lib; {
    description = "Library for creating background jobs and processing them";
    homepage = "https://github.com/nvie/rq/";
    changelog = "https://github.com/rq/rq/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mrmebelman ];
  };
}

