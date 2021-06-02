{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "prayer-times-calculator";
  version = "0.0.5";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "uchagani";
    repo = pname;
    rev = version;
    sha256 = "sha256-wm1r0MK6dx0cJvyQ7ulxvGWyIrNiPV2RXJD/IuKP3+E=";
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
