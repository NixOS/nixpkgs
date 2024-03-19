{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools

  # propagated
, cryptography
, django
, djangorestframework
, josepy
, requests

  # testing
, mock
}:

buildPythonPackage rec {
  pname = "mozilla-django-oidc";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "mozilla-django-oidc";
    rev = "refs/tags/${version}";
    hash = "sha256-72F1aLLIId+YClTrpOz3bL8LSq6ZhZjjtv8V/GJGkqs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    django
    djangorestframework
    josepy
    requests
  ];

  checkPhase = ''
    export PYTHONPATH=.:$PYTHONPATH
    ${django}/bin/django-admin test
  '';

  pythonImportsCheck = [
    "mozilla_django_oidc"
  ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    mock
  ];

  meta = with lib; {
    description = "A django OpenID Connect library";
    homepage = "https://mozilla-django-oidc.readthedocs.io/en/stable/index.html";
    changelog = "https://github.com/mozilla/mozilla-django-oidc/releases/tag/${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ rogryza ];
  };
}
