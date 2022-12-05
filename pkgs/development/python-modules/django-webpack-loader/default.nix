{ lib
, buildPythonPackage
, django
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-webpack-loader";
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-agZTglc3cbr0AHVMTTnAkTsKKaRTqUHfuRIu6+0hVy8=";
  };

  propagatedBuildInputs = [
    django
  ];

  # django.core.exceptions.ImproperlyConfigured (path issue with DJANGO_SETTINGS_MODULE?)
  doCheck = false;

  pythonImportsCheck = [
    "webpack_loader"
  ];

  meta = with lib; {
    description = "Use webpack to generate your static bundles";
    homepage = "https://github.com/owais/django-webpack-loader";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
