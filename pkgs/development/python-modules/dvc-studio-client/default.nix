{ lib
, buildPythonPackage
, dulwich
, fetchFromGitHub
, gitpython
, pythonOlder
, requests
, setuptools-scm
, voluptuous
}:

buildPythonPackage rec {
  pname = "dvc-studio-client";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-m4UJRRwY+aJdPIMHPIWe3En7FCADeT1qCZnu3BJeYXc=";
=======
    hash = "sha256-yiNhvemeN3Dbs8/UvdTsy0K/FORoAy27tvT4ElwFxRk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dulwich
    gitpython
    requests
    voluptuous
  ];

  pythonImportsCheck = [
    "dvc_studio_client"
  ];

  # Tests try to access network
  doCheck = false;

  meta = with lib; {
    description = "Library to post data from DVC/DVCLive to Iterative Studio";
    homepage = "https://github.com/iterative/dvc-studio-client";
    changelog = "https://github.com/iterative/dvc-studio-client/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
