{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, mock
, bower
, pytestCheckHook
, pytest-django
, python
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "django-bower";
  version = "5.2.0";

  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nvbn";
    repo = "django-bower";
    rev = "refs/tags/${version}";
    hash = "sha256-TVsFPwdLZ6sMCbxFpMQH4DKQxAUOd8RTCzhrQaPsgf8=";
  };

  postPatch = ''
    substituteInPlace djangobower/conf.py \
      --replace "'bower'" "'${bower}/bin/bower'"
  '';

  propagatedBuildInputs = [
    django
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-django
  ];

  preCheck = ''
    export HOME=$TMPDIR
    export DJANGO_SETTINGS_MODULE=djangobower.test_settings
  '';

  disabledTests = [
    "test_freeze"
    "test_management_command"
    "test_find"
    "test_list"
  ];

  meta = with lib; {
    description = "Easy way to use bower with your Django project";
    homepage = "https://github.com/nvbn/django-bower/";
    changelog = "https://github.com/nvbn/django-bower/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
