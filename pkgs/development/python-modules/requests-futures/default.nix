<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "requests-futures";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9VpO+ABw4oWOfR5zEj0r+uryW5P9NDhNjd8UjitnY3M=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Tests are disabled because they require being online
  doCheck = false;

  pythonImportsCheck = [
    "requests_futures"
  ];
=======
{ buildPythonPackage, fetchPypi, requests, lib }:

buildPythonPackage rec {
  pname = "requests-futures";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35547502bf1958044716a03a2f47092a89efe8f9789ab0c4c528d9c9c30bc148";
  };

  propagatedBuildInputs = [ requests ];

  # tests are disabled because they require being online
  doCheck = false;

  pythonImportsCheck = [ "requests_futures" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Asynchronous Python HTTP Requests for Humans using Futures";
    homepage = "https://github.com/ross/requests-futures";
<<<<<<< HEAD
    changelog = "https://github.com/ross/requests-futures/blob/v${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ applePrincess ];
  };
}
