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
  version = "5.2.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "django_stubs_ext";
    inherit version;
    hash = "sha256-AMSuMHtTj1ZDr3YakUw/jk4/JfTnxtcJjxkGwNjyqsk=";
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
