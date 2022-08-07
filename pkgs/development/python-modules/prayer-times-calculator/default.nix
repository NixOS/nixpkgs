{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "prayer-times-calculator";
  version = "0.0.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "uchagani";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-0hXbgzEKrWk79Ldd37fqnkOELa+dAGtc80RQfDZ1JTI=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "prayer_times_calculator" ];

  meta = with lib; {
    description = "Python client for the Prayer Times API";
    homepage = "https://github.com/uchagani/prayer-times-calculator";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
