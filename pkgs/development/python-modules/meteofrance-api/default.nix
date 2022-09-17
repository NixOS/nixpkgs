{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-X8f0z9ZPXH7Wc3GqHmPptxpNxbHeezdOzw4gZCprumU=";
  };

  patches = [
    (fetchpatch {
      #  Switch to poetry-core
      url = "https://github.com/hacf-fr/meteofrance-api/commit/7536993fe38dfe3d0833da3fd750be9277aeffa6.patch";
      hash = "sha256-/4VgzoJxhaXoj1N1GNLJNvkQvv6IW9OcBJV6vg6kthM=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pytz
    requests
    urllib3
  ] ++ lib.optionals (pythonOlder "3.7") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    # https://github.com/hacf-fr/meteofrance-api/pull/378
    substituteInPlace pyproject.toml \
      --replace 'pytz = ">=2020.4,<2022.0"' 'pytz = ">=2020.4,<2023.0"'
  '';

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
