{
  pkgs,
  buildPythonPackage,
  django,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-autoslug";
  version = "1.9.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-efiOlDPByI2NPyvsYNZcqYv/r/bAcreKpf2Z0OhKE90=";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting AUTOSLUG_SLUGIFY_FUNCTION, but settings are not configured.
  doCheck = false;

  # django.core.exceptions.ImproperlyConfigured: Requested setting AUTOSLUG_SLUGIFY_FUNCTION, but settings are not configured.
  # pythonImportsCheck = [ "autoslug" ];

  meta = with pkgs.lib; {
    description = "Reusable Django library that provides an improved automatic slug field";
    homepage = "https://github.com/justinmayer/django-autoslug/";
    changelog = "https://github.com/justinmayer/django-autoslug/blob/v${version}/CHANGELOG.rst";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ ];
  };
}
