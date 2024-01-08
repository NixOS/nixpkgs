{ lib
, buildPythonPackage
, docopt
, fetchFromGitHub
, pythonOlder
, pytz
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "epion";
  version = "0.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devenzo-com";
    repo = "epion_python";
    # https://github.com/devenzo-com/epion_python/issues/1
    rev = "d8759951fc7bfd1507abe725b2bc98754cbbf505";
    hash = "sha256-uC227rlu4NB5lpca02QLi2JZ5SKklLfv7rXvvJA1aCA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    docopt
    pytz
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "epion"
  ];

  meta = with lib; {
    description = "Module to access Epion sensor data";
    homepage = "https://github.com/devenzo-com/epion_python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
