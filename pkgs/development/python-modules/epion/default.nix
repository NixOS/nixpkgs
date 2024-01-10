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
  version = "0.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devenzo-com";
    repo = "epion_python";
    rev = "refs/tags/${version}";
    hash = "sha256-XyYjbr0EPRrwWsXhZT2oWcoDPZoZCuT9aZ2UHSSt0E8=";
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
