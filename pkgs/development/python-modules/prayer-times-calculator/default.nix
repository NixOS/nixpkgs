{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "prayer-times-calculator";
  version = "0.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "uchagani";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-T+rXJy+9haepF6TKSoOjb6o75YQwQnzAaWRtLMwfGOw=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "prayer_times_calculator"
  ];

  meta = with lib; {
    description = "Python client for the Prayer Times API";
    homepage = "https://github.com/uchagani/prayer-times-calculator";
    changelog = "https://github.com/uchagani/prayer-times-calculator/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
