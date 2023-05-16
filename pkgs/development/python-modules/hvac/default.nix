{ lib
, buildPythonPackage
, fetchPypi
, pyhcl
, requests
<<<<<<< HEAD
, poetry-core
=======
, six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hvac";
<<<<<<< HEAD
  version = "1.2.0";
  format = "pyproject";
=======
  version = "1.1.0";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-b1qg1rgTi1hdRlbR/gG12HYWMQyASEuQnMhMLLjwZP0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pyhcl
    requests
=======
    hash = "sha256-B53KWIVt7mZG7VovIoOAnBbS3u3eHp6WFbKRAySkuWk=";
  };

  propagatedBuildInputs = [
    pyhcl
    requests
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Requires running a Vault server
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [
    "hvac"
  ];
=======
  pythonImportsCheck = [ "hvac" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "HashiCorp Vault API client";
    homepage = "https://github.com/ianunruh/hvac";
    changelog = "https://github.com/hvac/hvac/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
