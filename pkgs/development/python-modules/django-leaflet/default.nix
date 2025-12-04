{
  pkgs,
  buildPythonPackage,
  django,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-leaflet";
  version = "0.33.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "django_leaflet";
    inherit version;
    hash = "sha256-tRxx5xee7ZlhSE39V7h70ezjsf977k37f01XAiBrLso=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  # The tests seem to be impure.
  # They are throwing a error about unset configs:
  # > django.core.exceptions.ImproperlyConfigured: Requested setting LEAFLET_CONFIG, but settings are not configured.
  doCheck = false;

  # This dosn't work either because of the same exception as above
  # pythonImportsCheck = [ "leaflet" ];

  meta = with pkgs.lib; {
    description = "Allows you to use Leaflet in your Django projects";
    homepage = "https://github.com/makinacorpus/django-leaflet";
    changelog = "https://github.com/makinacorpus/django-leaflet/blob/${version}/CHANGES";
    license = licenses.lgpl3Only;
    maintainers = [ ];
  };
}
