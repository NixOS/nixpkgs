{ lib
, fetchPypi
, buildPythonPackage
, django
, zstandard
, brotli
}:

buildPythonPackage rec {
  pname = "django-compression-middleware";
  version = "0.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cdS80JVGz4h4MVCsZGfrQWhZlTR3Swm4Br4wFxOcKVs=";
  };

  propagatedBuildInputs = [
    django
    zstandard
    brotli
  ];

  meta = with lib; {
    description = "Django middleware to compress responses using several algorithms";
    homepage = "https://github.com/friedelwolff/django-compression-middleware";
    changelog = "https://github.com/friedelwolff/django-compression-middleware/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ e1mo ];
  };
}
