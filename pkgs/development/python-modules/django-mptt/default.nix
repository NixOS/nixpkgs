{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  django-js-asset,
}:

buildPythonPackage rec {
  pname = "django-mptt";
  version = "0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-mptt";
    repo = "django-mptt";
    rev = version;
    hash = "sha256-vWnXKWzaa5AWoNaIc8NA1B2mnzKXRliQmi5VdrRMadE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    django-js-asset
  ];

  pythonImportsCheck = [ "mptt" ];

  # No pytest checks, since they depend on model_mommy, which is deprecated
  doCheck = false;

  meta = with lib; {
    description = "Utilities for implementing a modified pre-order traversal tree in Django";
    homepage = "https://github.com/django-mptt/django-mptt";
    maintainers = with maintainers; [ hexa ];
    license = with licenses; [ mit ];
  };
}
