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
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-scopes";
    tag = finalAttrs.version;
    hash = "sha256-CtToztLVvSb91pMpPNL8RysQJzlRkeXuQbpvbkX3jfM=";
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
