{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  poetry-core,
  python,
  ua-parser,
}:

buildPythonPackage rec {
  pname = "django-sesame";
  version = "3.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = "django-sesame";
    tag = version;
    hash = "sha256-avvt1GWhucoxY/ER0sxEQCmNdWFHiMKcCuD/ZCacwNo=";
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

  meta = {
    description = "URLs with authentication tokens for automatic login";
    homepage = "https://github.com/aaugustin/django-sesame";
    changelog = "https://github.com/aaugustin/django-sesame/blob/${version}/docs/changelog.rst";
    license = lib.licenses.bsd3;
  };
}
