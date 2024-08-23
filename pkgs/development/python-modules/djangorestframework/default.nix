{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  coreapi,
  django,
  django-guardian,
  pythonOlder,
  pytest-django,
  pytest7CheckHook,
  pytz,
  pyyaml,
  uritemplate,
}:

buildPythonPackage rec {
  pname = "djangorestframework";
  version = "3.14.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "django-rest-framework";
    rev = version;
    hash = "sha256-Fnj0n3NS3SetOlwSmGkLE979vNJnYE6i6xwVBslpNz4=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-21520.patch";
      url = "https://github.com/encode/django-rest-framework/commit/3b41f0124194430da957b119712978fa2266b642.patch";
      hash = "sha256-1NoRlV+sqHezDo28x38GD6DpcQuUF1q3YQXEb3SUvKQ=";
    })
  ];

  propagatedBuildInputs = [
    django
    pytz
  ];

  nativeCheckInputs = [
    pytest-django
    pytest7CheckHook

    # optional tests
    coreapi
    django-guardian
    pyyaml
    uritemplate
  ];

  pythonImportsCheck = [ "rest_framework" ];

  meta = with lib; {
    description = "Web APIs for Django, made easy";
    homepage = "https://www.django-rest-framework.org/";
    maintainers = with maintainers; [ desiderius ];
    license = licenses.bsd2;
  };
}
