{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "logging-journald";
<<<<<<< HEAD
  version = "0.6.5";
=======
  version = "0.6.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-EyKXc/Qr9mRFngDqbCPNVs/0eD9OCbQq0FbymA6kpLQ=";
=======
    hash = "sha256-g8oDFuqTBVutS7Uq7JCN+SXYL7UEQ+7G2nxzndjKAh8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  # Circular dependency with aiomisc
  doCheck = false;

  pythonImportsCheck = [
    "logging_journald"
  ];

  meta = with lib; {
    description = "Logging handler for writing logs to the journald";
    homepage = "https://github.com/mosquito/logging-journald";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
