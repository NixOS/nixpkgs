{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, requests
, django
, boto3
, hatchling
, python
, mock
, responses
}:

buildPythonPackage rec {
  pname = "django-anymail";
  version = "10.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "anymail";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-unmbYQFLeqfqE1uFLMPLUad1UqA+sgbTzwRfpRhM3ik=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    requests
    django
  ];

  nativeCheckInputs = [
    mock
    responses
  ] ++ passthru.optional-dependencies.amazon-ses;

  passthru.optional-dependencies = {
    amazon-ses = [ boto3 ];
  };

  checkPhase = ''
    runHook preCheck
    CONTINUOUS_INTEGRATION=1 python runtests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "anymail" ];

  meta = with lib; {
    description = "Django email backends and webhooks for Mailgun";
    homepage = "https://github.com/anymail/django-anymail";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
