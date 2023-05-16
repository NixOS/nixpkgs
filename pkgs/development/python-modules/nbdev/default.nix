{ lib
, buildPythonPackage
, fetchPypi
, fastprogress
, fastcore
, asttokens
, astunparse
, watchdog
, execnb
, ghapi
, pyyaml
, quarto
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nbdev";
<<<<<<< HEAD
  version = "2.3.12";
=======
  version = "2.3.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-AQWNqCq9IEWMKkkG5bw0pkvWtvIMKkBbAotfTRRTMCQ=";
=======
    sha256 = "sha256-ITMCmuAb1lXONbP5MREpk8vfNSztoTEmT87W1o+fbIU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    fastprogress
    fastcore
    asttokens
    astunparse
    watchdog
    execnb
    ghapi
    pyyaml
    quarto
  ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "nbdev" ];

  meta = with lib; {
    homepage = "https://github.com/fastai/nbdev";
    description = "Create delightful software with Jupyter Notebooks";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
  };
}
