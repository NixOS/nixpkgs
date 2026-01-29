{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  pytest-django,
  pytestCheckHook,
  setuptools-scm,
  pillow,
  pytest-cov,
  gettext,
  pythonOlder,
  pythonAtLeast,
}:
buildPythonPackage rec {
  pname = "django-stdimage";
  version = "6.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = "django-stdimage";
    tag = version;
    hash = "sha256-uwVU3Huc5fitAweShJjcMW//GBeIpJcxqKKLGo/EdIs=";
  };

  disabled = pythonOlder "3.8" || pythonAtLeast "3.13";

  dependencies = [
    django
    pillow
  ];

  build-system = [ setuptools-scm ];
  nativeBuildInputs = [ gettext ];

  doCheck = true;
  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';
  disabledTests = [
    # SuspiciousFileOperation: Detected path traversal attempt (Even appear in upstream)
    "test_variations_override"
  ];
  pythonImportsCheck = [
    "stdimage"
    "stdimage.validators"
    "stdimage.models"
  ];
  nativeCheckInputs = [
    pytest-django
    pytest-cov
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Django Standardized Image Field";
    homepage = "https://github.com/codingjoe/django-stdimage";
    changelog = "https://github.com/codingjoe/django-stdimage/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kurogeek ];
  };
}
