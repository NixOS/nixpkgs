{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, pytz
, requests
, requests-mock
, typing-extensions
, urllib3
}:

buildPythonPackage rec {
  pname = "meteofrance-api";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-W26R+L2ZJpycEQ9KwkHqVARKsd/5YkJCxMeciKnKAX8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pytz
    requests
    typing-extensions
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "meteofrance_api"
  ];

  disabledTests = [
    # Tests require network access
    "test_currentphenomenons"
    "test_forecast"
    "test_full_with_coastal_bulletint"
    "test_fulls"
    "test_no_rain_expected"
    "test_picture_of_the_day"
    "test_places"
    "test_rain"
    "test_session"
    "test_observation"
    "test_workflow"
  ];

  meta = with lib; {
    description = "Module to access information from the Meteo-France API";
    homepage = "https://github.com/hacf-fr/meteofrance-api";
    changelog = "https://github.com/hacf-fr/meteofrance-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
