{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, requests
, beautifulsoup4
, colorama
}:

buildPythonPackage rec {
  pname = "hydra-check";
<<<<<<< HEAD
  version = "1.3.5";
=======
  version = "1.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-fRSC+dfZZSBBeN6YidXRKc1kPUbBKz5OiFSHGOSikgI=";
=======
    rev = "v${version}";
    hash = "sha256-voSbpOPJUPjwzdMLVt2TC/FIi6LKk01PLd/GczOAUR8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [
    colorama
    requests
    beautifulsoup4
  ];

  pythonImportsCheck = [ "hydra_check" ];

  meta = with lib; {
    description = "check hydra for the build status of a package";
    homepage = "https://github.com/nix-community/hydra-check";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu artturin ];
  };
}
