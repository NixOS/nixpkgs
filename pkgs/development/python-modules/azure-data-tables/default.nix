{ lib
, buildPythonPackage
, fetchPypi
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-data-tables";
<<<<<<< HEAD
  version = "12.4.3";
=======
  version = "12.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-qLA0vNRyIu36xKwB55BD/TCTOv+nmyOtk3+Y4P+SalI=";
=======
    hash = "sha256-Oz1dFbKpY+CbSTSx/iuiF/Kd2axRghwXVJ/K+HRwJDQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-core
    msrest
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.data.tables" ];

  meta = with lib; {
    description = "NoSQL data storage service that can be accessed from anywhere";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
