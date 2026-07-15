{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-context-decorator";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rixx";
    repo = "django-context-decorator";
    rev = "v${version}";
    hash = "sha256-lNmZDsguOu2+gtMVjbwr709sbLCQOQ1sAePN7UJQbcw=";
  };

  build-system = [ flit-core ];

  pythonImportsCheck = [ "django_context_decorator" ];

  nativeCheckInputs = [
    django
    pytestCheckHook
  ];

  meta = {
    description = "Django @context decorator";
    homepage = "https://github.com/rixx/django-context-decorator";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
