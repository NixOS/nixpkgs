{
  pkgs,
  buildPythonPackage,
  django,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-leaflet";
  version = "0.29.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ECtocPJHYR1DsFLeVMVdtlia4UNOJyNMsU1CrX1aVsQ=";
  };

  propagatedBuildInputs = [ django ];

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
    maintainers = with maintainers; [ janik ];
  };
}
