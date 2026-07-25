{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-scopes";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-scopes";
    tag = finalAttrs.version;
    hash = "sha256-VtZfwWS6qcY1kthJ6qXf/nwxZpJxu5x41xjjR58wCM0=";
  };

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "django_scopes" ];

  meta = {
    description = "Safely separate multiple tenants in a Django database";
    homepage = "https://github.com/raphaelm/django-scopes";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
