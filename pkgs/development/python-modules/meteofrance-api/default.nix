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
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1ZN/9ur6uhK7M5TurmmWgUjzkc79MPqKnT637hbAAWA=";
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
    "test_workflow"
  ];

  meta = with lib; {
    description = "Module to access information from the Meteo-France API";
    homepage = "https://github.com/hacf-fr/meteofrance-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
