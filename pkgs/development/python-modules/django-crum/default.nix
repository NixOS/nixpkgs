{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-crum";
  version = "0.7.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NZycLpVYpfBwMnKjHbQwZ/aiP6Vb2v71+Bz+Adphagg=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [ "crum" ];

  meta = {
    description = "Current Authenticated User Middleware for Django";
    homepage = "https://github.com/ninemoreminutes/django-crum";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
