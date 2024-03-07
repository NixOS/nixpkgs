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
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "meteofrance-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-uSrVK6LwCDyvsjzGl4xQd8585Hl6sp2Ua9ly0wqnC1Y=";
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
    "test_dictionary"
    "test_forecast"
    "test_full_with_coastal_bulletin"
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
