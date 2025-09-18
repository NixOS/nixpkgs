{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  poetry-core,
  python,
  pythonOlder,
  ua-parser,
}:

buildPythonPackage rec {
  pname = "django-sesame";
  version = "3.2.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = "django-sesame";
    tag = version;
    hash = "sha256-JpbmcV5hAZkW15cizsAJhmTda4xtML0EY/PJdVSInUs=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    django
    ua-parser
  ];

  pythonImportsCheck = [ "sesame" ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m django test --settings=tests.settings

    runHook postCheck
  '';

  meta = with lib; {
    description = "URLs with authentication tokens for automatic login";
    homepage = "https://github.com/aaugustin/django-sesame";
    changelog = "https://github.com/aaugustin/django-sesame/blob/${version}/docs/changelog.rst";
    license = licenses.bsd3;
  };
}
