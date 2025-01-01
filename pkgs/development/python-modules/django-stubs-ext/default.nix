{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  oracledb,
  pytestCheckHook,
  pythonOlder,
  redis,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "django-stubs-ext";
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "django_stubs_ext";
    inherit version;
    hash = "sha256-7X1RwLcxZRh5/HXzMfsIBtmLZ7+rRk6W4nJNtrRu+SY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    typing-extensions
  ];

  optional-dependencies = {
    redis = [ redis ];
    oracle = [ oracledb ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "django_stubs_ext" ];

  meta = with lib; {
    description = "Extensions and monkey-patching for django-stubs";
    homepage = "https://github.com/typeddjango/django-stubs";
    changelog = "https://github.com/typeddjango/django-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
