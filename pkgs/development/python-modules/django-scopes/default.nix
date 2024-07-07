{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-scopes";
  version = "2.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-scopes";
    rev = "refs/tags/${version}";
    hash = "sha256-CtToztLVvSb91pMpPNL8RysQJzlRkeXuQbpvbkX3jfM=";
  };

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "django_scopes" ];

  meta = with lib; {
    description = "Safely separate multiple tenants in a Django database";
    homepage = "https://github.com/raphaelm/django-scopes";
    license = licenses.asl20;
    maintainers = with maintainers; [ ambroisie ];
  };
}
