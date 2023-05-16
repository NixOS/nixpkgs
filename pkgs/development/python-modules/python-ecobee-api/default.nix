{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "python-ecobee-api";
<<<<<<< HEAD
  version = "0.2.17";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lJCbNOQJ8xmMa4V+tSFZx4QasK8ZLfsFavMP9Zge4K4=";
=======
  version = "0.2.16";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wzL1WylQAFLxWu3lDFqQtLxJbQjse4OX/fbzaaEuvGQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyecobee" ];

  meta = with lib; {
    description = "Python API for talking to Ecobee thermostats";
    homepage = "https://github.com/nkgilley/python-ecobee-api";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
