{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "django-admin-datta";
  version = "1.0.19";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-65fUrV4FIbuVvNX93rgOCMjz4CoozMHEEVpzJqtbhKY=";
  };

  propagatedBuildInputs = [ django ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "admin_datta" ];

  meta = {
    description = "Modern template for Django that covers Admin Section";
    homepage = "https://appseed.us/product/datta-able/django";
    changelog = "https://github.com/app-generator/django-admin-datta/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
