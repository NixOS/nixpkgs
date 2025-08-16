{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  oracledb,
  pytestCheckHook,
  pythonOlder,
  redis,
  hatchling,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "django-stubs-ext";
  version = "5.2.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "django_stubs_ext";
    inherit version;
    hash = "sha256-2dFRuRn+JDh2D1vZOPA+HLCMhNBlH55ZF/ExOQfkJoM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    typing-extensions
  ];

  optional-dependencies = {
    redis = [ redis ];
    oracle = [ oracledb ];
  };

  # Tests are not shipped with PyPI
  doCheck = false;

  pythonImportsCheck = [ "django_stubs_ext" ];

  meta = with lib; {
    description = "Extensions and monkey-patching for django-stubs";
    homepage = "https://github.com/typeddjango/django-stubs";
    changelog = "https://github.com/typeddjango/django-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
